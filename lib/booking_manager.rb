module Hotel
  
  class BookingManager
    attr_reader :all_rooms, :all_reservations, :all_blocks
    
    def initialize
      # This is a list of all of the rooms in the hotel
      @all_rooms = Hotel::Room.all
      @all_reservations = {}
      @all_blocks = {}
    end
    
    def find_room(room_num)
      correct_room = all_rooms[room_num.to_s]  
      return correct_room
    end
    
    def find_reservation(reservation_num)
      correct_reservation = all_reservations[reservation_num.to_s]
      return correct_reservation
    end
    
    def change_room_cost(room_num:, new_cost:)
      room = find_room(room_num)
      room.change_cost(new_cost)
    end
    
    def available_rooms(check_in:, check_out:)
      available_rooms = []
      
      all_rooms.each do |number, room|
        result = room.available?(check_in: check_in, check_out: check_out)        
        available_rooms << room if result
      end        
      return available_rooms
    end
    
    def make_reservation(check_in:, check_out:, status: :CONFIRMED, discount: nil)      
      id = all_reservations.length + 1
      room = available_rooms(check_in: check_in, check_out: check_out)[0]
      
      if !room
        raise NoAvailableRoomError.new("There are no available rooms for those dates.")
      end
      
      reservation = Hotel::Reservation.new(
        id: id, room: room, check_in: check_in, check_out: check_out, status: status, discount: discount
      )
      all_reservations[id.to_s] = reservation
      room.add_reservation(reservation)
      
      return reservation
    end
    
    # This will find available rooms for you, so you don't need to specify them
    # You will have to enter a name for your party
    # Enter discount as a whole number (50 for 50%)
    def make_block(name:, check_in:, check_out:, num_rooms:, discount:)
      if find_block(name)
        raise BlockNameError.new("There is already a room block under name #{name}.")
      end
      
      rooms = available_rooms(check_in: check_in, check_out: check_out)
      
      if rooms.length < num_rooms
        raise NoAvailableRoomError.new("There are not enough hotel rooms for a block of #{num_rooms} on those dates.")
      end
      
      block = Hotel::RoomBlock.new(
        name: name, check_in: check_in, check_out: check_out, num_rooms: num_rooms, discount: discount
      )
      
      num_rooms.times do
        reservation = make_reservation(check_in: check_in, check_out: check_out, status: :HOLD, discount: block.discount)
        block.add_reservation(reservation)
      end  
      
      all_blocks[block.name] = block
      return block
    end
    
    def find_block(name)
      correct_block = all_blocks[name.capitalize]
      return correct_block
    end
    
    # Allows you to reserve a room from a hotel block
    def make_block_reservation(name)
      block = find_block(name)
      reservation = block.confirm_reservation
      return reservation
    end
    
    # Includes new and current guests, but not people who checked out on that date.
    # Shows confirmed reservations, but not unconfirmed rooms being held for a room block
    def find_day_reservations(date)
      day_reservations = all_reservations.select do |number, reservation|
        start_date = reservation.check_in
        end_date = reservation.check_out
        (start_date...end_date).include?(Date.parse(date)) && reservation.status == :CONFIRMED
      end
      
      return day_reservations
    end
    
    def save_rooms(filename)
      CSV.open(filename, "w") do |file|
        headers = ["id", "nightly_cost", "reservations"]
        file << headers
        
        all_rooms.each do |number, room|
          reservations = room.reservations.map do |reservation|
            reservation.id
          end
          
          if reservations == []
            reservation_list = nil
          else
            reservation_list = reservations.join(";")
          end
          
          row = [room.id, room.nightly_cost, reservation_list]
          file << row
        end
      end
    end
    
    def save_reservations(filename)
      CSV.open(filename, "w") do |file|
        headers = ["id", "room", "check_in", "check_out", "status", "discount"]
        file << headers
        
        all_reservations.each do |number, reservation|
          row = [
            reservation.id, 
            reservation.room.id, 
            reservation.check_in, 
            reservation.check_out, 
            reservation.status, 
            reservation.discount
          ]
          file << row  
        end
      end
    end
    
    def save_blocks(filename)
      CSV.open(filename, "w") do |file|
        headers = ["name", "check_in", "check_out", "num_rooms", "discount", "reservations"]
        file << headers
        
        all_blocks.each do |name, block|
          reservations = block.reservations.map do |reservation|
            reservation.id
          end
          
          row = [
            block.name, 
            block.check_in, 
            block.check_out, 
            block.num_rooms, 
            block.discount * 100, 
            reservations.join(";")
          ]
          file << row  
        end
      end
    end
    
    def load_files(rooms_file, reservations_file, blocks_file)
      rooms = CSV.read(rooms_file, headers: true, converters: :numeric).map { |record| Hotel::Room.from_csv(record) }
      
      @all_rooms = {}
      
      rooms.each_with_index do |room, index|
        @all_rooms[(index + 1).to_s] = room
      end
      
      reservations = CSV.read(reservations_file, headers: true, converters: :numeric).map { |record| Hotel::Reservation.from_csv(record) }
      
      @all_reservations = {}
      
      reservations.map do |reservation|
        reservation.room = find_room(reservation.room)
      end
      
      reservations.each_with_index do |reservation, index|
        @all_reservations[(index + 1).to_s] = reservation
      end
      
      blocks = CSV.read(blocks_file, headers: true, converters: :numeric).map { |record| Hotel::RoomBlock.from_csv(record) }
      
      @all_blocks = {}
      
      blocks.map do |block|
        list = block.reservations.split(";")
        
        block.reservations = list.map do |number|
          find_reservation(number.to_i)
        end
      end
      
      blocks.each do |block|
        @all_blocks[block.name] = block
      end
      
      @all_rooms.each do |number, room|
        if !room.reservations.empty?
          room.reservations.map! do |number|
            find_reservation(number)
          end
        end  
      end
    end
  end
end

module Hotel
  
  class BookingManager
    attr_reader :all_rooms, :all_reservations, :all_blocks
    
    def initialize
      # This is a list of all of the rooms in the hotel
      @all_rooms = Hotel::Room.all
      @all_reservations = []
      @all_blocks = []
    end
    
    def room_available?(check_in:, check_out:, room:)
      room.reservations.each do |reservation|
        day = Date.parse(check_in)
        last_day = Date.parse(check_out)
        
        while day != last_day
          return false if (reservation.check_in...reservation.check_out).include?(day)
          day += 1          
        end
      end
      return true
    end
    
    def available_rooms(check_in:, check_out:)
      available_rooms = []
      
      all_rooms.each do |room|
        result = room_available?(check_in: check_in, check_out: check_out, room: room)        
        available_rooms << room if result
      end        
      return available_rooms
    end
    
    def make_reservation(check_in:, check_out:, status: :CONFIRMED, discount: nil)
      id = all_reservations.length + 1
      room = available_rooms(check_in: check_in, check_out: check_out)[0]
      
      if !room
        raise ArgumentError.new("There are no available rooms for those dates.")
      end
      
      reservation = Hotel::Reservation.new(
        id: id, room: room, check_in: check_in, check_out: check_out, status: status, discount: discount
      )
      all_reservations << reservation
      room.add_reservation(reservation)
      
      return reservation
    end
    
    # This will find available rooms for you, so you don't need to specify them
    # You will have to enter a name for your party
    # Enter discount as a whole number (50 for 50%)
    def make_block(name:, check_in:, check_out:, num_rooms:, discount:)
      rooms = available_rooms(check_in: check_in, check_out: check_out)
      
      if rooms.length < num_rooms
        raise ArgumentError.new("There are not enough hotel rooms for a block of #{num_rooms} on those dates.")
      end
      
      block = Hotel::RoomBlock.new(
        name: name, check_in: check_in, check_out: check_out, num_rooms: num_rooms, discount: discount
      )
      
      num_rooms.times do
        reservation = make_reservation(check_in: check_in, check_out: check_out, status: :HOLD, discount: discount)
        block.add_reservation(reservation)
      end  
      
      all_blocks << block
      return block
    end
    
    def find_block(name)
      correct_block = all_blocks.find do |block|
        block.name == name.capitalize
      end
      return correct_block
    end
    
    # Allows you to reserve a room from a hotel block
    def make_block_reservation(name)
      block = find_block(name)
      reservation = block.available_rooms[0]
      
      if !reservation
        raise ArgumentError.new("There are no more available rooms from that block.")
      end
      
      reservation.confirm_reservation
      
      return reservation
    end
    
    # Includes new and current guests, but not people who checked out on that date.
    # Shows confirmed reservations, but not unconfirmed rooms being held for a room block
    def find_reservations(date)
      day_reservations = all_reservations.select do |reservation|
        start_date = reservation.check_in
        end_date = reservation.check_out
        (start_date...end_date).include?(Date.parse(date)) && reservation.status == :CONFIRMED
      end
      
      return day_reservations
    end
  end
end

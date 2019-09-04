module Hotel
  
  class BookingManager
    attr_reader :all_rooms, :all_reservations
    
    def initialize
      @all_rooms = Hotel::Room.all
      @all_reservations = []
    end
    
    def available?(check_in, check_out, room)
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
    
    def available_rooms(check_in, check_out)
      available_rooms = []
      
      all_rooms.each do |room|
        result = available?(check_in, check_out, room)        
        available_rooms << room if result
      end        
      return available_rooms
    end
    
    def available_room_names(check_in, check_out)
      available_rooms = available_rooms(check_in, check_out)
      room_names = []
      
      available_rooms.each do |room|
        room_names << room.id
      end
      
      formatted_string = "Available rooms for #{check_in} to #{check_out}:\n#{room_names.join(", ")}"
      return formatted_string
    end
    
    def make_reservation(check_in, check_out)
      id = all_reservations.length + 1
      room = available_rooms(check_in, check_out)[0]
      
      if !room
        raise ArgumentError.new("There are no available rooms for those dates.")
      end
      
      reservation = Hotel::Reservation.new(id, room, check_in, check_out)
      all_reservations << reservation
      room.reservations << reservation
      
      return reservation
    end
    
    # Includes new and current guests, but not people who checked out on that date.
    def find_reservations(date)
      day_reservations = all_reservations.select do |reservation|
        start_date = reservation.check_in
        end_date = reservation.check_out
        (start_date...end_date).include?(Date.parse(date))
      end
      
      return day_reservations
    end
  end
end

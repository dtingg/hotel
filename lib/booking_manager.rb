module Hotel
  
  class BookingManager
    attr_reader :all_rooms, :all_reservations
    
    def initialize
      @all_rooms = Hotel::Room.all
      @all_reservations = []
    end
    
    def make_reservation(check_in, check_out)
      id = all_reservations.length + 1
      room = all_rooms[0]
      
      reservation = Hotel::Reservation.new(id, room, check_in, check_out)
      all_reservations << reservation
      room.reservations << reservation
      
      return reservation
    end
    
    def find_reservations(date)
      day_reservations = all_reservations.select do |reservation|
        reservation.check_in == Date.parse(date)
      end
      
      return day_reservations
    end
  end
end

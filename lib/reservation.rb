module Hotel
  
  class Reservation
    attr_reader :id, :room, :check_in, :check_out
    
    def initialize(id, room, check_in, check_out)
      @id = id
      @room = room
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
    end
    
    def total_cost
      nights = check_out - check_in
      
      return nights * room.nightly_cost
    end
  end
end

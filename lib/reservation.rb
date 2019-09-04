module Hotel
  
  class Reservation
    attr_reader :id, :room, :check_in, :check_out
    
    def initialize(id, room, check_in, check_out)
      @id = id
      @room = room
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
      
      if @check_in > @check_out
        raise ArgumentError.new("The check in date cannot be after the check out date.")
      end  
    end
    
    def total_cost
      nights = check_out - check_in
      
      return nights * room.nightly_cost
    end
  end
end

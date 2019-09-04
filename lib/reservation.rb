module Hotel
  
  class Reservation
    attr_reader :id, :room, :check_in, :check_out, :status, :discount
    
    def initialize(id, room, check_in, check_out, status = :CONFIRMED, discount = nil)
      @id = id
      @room = room
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
      @status = status
      @discount = discount
      
      if @check_in > @check_out
        raise ArgumentError.new("The check in date cannot be after the check out date.")
      end  
    end
    
    def total_cost
      nights = check_out - check_in
      
      subtotal = nights * room.nightly_cost
      
      total = discount ? subtotal - (subtotal * discount) : subtotal
      return total
    end
  end
end

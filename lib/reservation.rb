module Hotel
  
  class Reservation
    attr_reader :id, :check_in, :check_out, :status, :discount
    attr_accessor :room
    
    def initialize(id: , room:, check_in:, check_out:, status: :CONFIRMED, discount: nil)
      @id = id
      @room = room
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
      
      if @check_in > @check_out
        raise CheckInDateError.new("The check in date cannot be after the check out date.")
      end  
      
      @status = status
      @discount = discount
    end
    
    def confirm_reservation
      @status = :CONFIRMED
    end
    
    def total_cost
      nights = check_out - check_in
      subtotal = nights * room.nightly_cost
      
      total = discount ? subtotal - (subtotal * discount) : subtotal
      return total
    end
    
    def self.from_csv(record)
      reservation = self.new(
        id: record["id"],
        room: record["room"],
        check_in: record["check_in"],
        check_out: record["check_out"],
        status: record["status"].to_sym,
        discount: record["discount"]
      )
      return reservation
    end
  end
end

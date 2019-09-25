module Hotel
  
  class RoomBlock
    attr_reader :name, :check_in, :check_out, :num_rooms, :discount
    attr_accessor :reservations
    
    def initialize(name: , check_in: , check_out: , num_rooms: , discount:, reservations: [])
      @name = name.capitalize  
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
      
      if @check_in > @check_out
        raise CheckInDateError.new("The check in date cannot be after the check out date.")
      end  
      
      if num_rooms <= 0 || num_rooms > 5
        raise BlockNumberError.new("A block can only contain 1 - 5 rooms.")
      end
      
      @num_rooms = num_rooms
      @discount = discount / 100.0
      @reservations = reservations
    end
    
    def add_reservation(reservation)
      reservations << reservation
    end
    
    # This allows you to view the available rooms left in a block
    def available_rooms
      available_rooms = reservations.select do |reservation|
        reservation.status == :HOLD
      end
      
      return available_rooms
    end
    
    # Confirm a reservation in a block
    def confirm_reservation
      reservation = available_rooms[0]
      
      if !reservation
        raise ArgumentError.new("There are no more available rooms from that block.")
      end
      
      reservation.confirm_reservation
      return reservation
    end
    
    def self.from_csv(record)
      block = self.new(
        name: record["name"], 
        check_in: record["check_in"], 
        check_out: record["check_out"],
        num_rooms: record["num_rooms"],
        discount: record["discount"],
        reservations: record["reservations"]      
      )
      return block
    end
  end
end

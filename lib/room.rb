module Hotel
  
  class Room    
    NUMBER_OF_ROOMS = 20
    
    attr_reader :id, :nightly_cost
    attr_accessor :reservations
    
    def initialize(id:, nightly_cost: 200, reservations: [])
      if id <= 0 || id > 20
        raise ArgumentError.new("The hotel only has rooms 1 - 20.")
      end
      
      @id = id
      @nightly_cost = nightly_cost
      @reservations = reservations
    end
    
    def change_cost(new_cost)
      @nightly_cost = new_cost
    end
    
    def available?(check_in:, check_out:)
      reservations.each do |reservation|
        day = Date.parse(check_in)
        last_day = Date.parse(check_out)
        
        while day != last_day
          return false if (reservation.check_in...reservation.check_out).include?(day)
          day += 1          
        end
      end
      return true
    end
    
    def add_reservation(reservation)
      reservations << reservation
    end
    
    def self.all
      all_rooms = []
      
      NUMBER_OF_ROOMS.times do |i|
        all_rooms << self.new(id: i + 1)
      end
      
      return all_rooms
    end
  end
end

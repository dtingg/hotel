module Hotel
  
  class Room    
    NUMBER_OF_ROOMS = 20
    
    attr_reader :id, :nightly_cost, :reservations
    
    def initialize(id)
      if id <= 0 || id > 20
        raise ArgumentError.new("The hotel only has rooms 1 - 20.")
      end
      
      @id = id
      @nightly_cost = 200
      @reservations = []
    end
    
    def change_cost(new_cost)
      @nightly_cost = new_cost
    end
    
    def add_reservation(reservation)
      reservations << reservation
    end
    
    def self.all
      all_rooms = []
      
      NUMBER_OF_ROOMS.times do |i|
        all_rooms << self.new(i + 1)
      end
      
      return all_rooms
    end
  end
end

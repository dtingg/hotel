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
  end
end

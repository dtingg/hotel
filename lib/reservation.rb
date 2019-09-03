module Hotel
  
  class Reservation
    attr_reader :id
    
    def initialize(id:, room:, check_in:, check_out:)
      @id = id
    end
  end
end

module Hotel
  
  class RoomBlock
    attr_reader :name, :check_in, :check_out
    
    def initialize(name, check_in, check_out)
      @name = name.capitalize
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
      
      if @check_in > @check_out
        raise ArgumentError.new("The check in date cannot be after the check out date.")
      end  
    end
  end
end

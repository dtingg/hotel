module Hotel
  
  class DateRange
    attr_reader :check_in, :check_out
    
    def initialize(check_in, check_out)
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
    end
  end
end

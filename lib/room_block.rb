module Hotel
  
  class RoomBlock
    attr_reader :name, :check_in, :check_out, :num_rooms, :room_array, :discount, :reservations
    
    def initialize(name, check_in, check_out, num_rooms, room_array, discount)
      @name = name.capitalize  
      @check_in = Date.parse(check_in)
      @check_out = Date.parse(check_out)
      
      if @check_in > @check_out
        raise ArgumentError.new("The check in date cannot be after the check out date.")
      end  
      
      if num_rooms <= 0 || num_rooms > 5
        raise ArgumentError.new("A block can only contain 1 - 5 rooms.")
      end
      @num_rooms = num_rooms
      
      @room_array = room_array
      
      if room_array.length != num_rooms
        raise ArgumentError.new("There are not enough rooms for this hotel block.")
      end
      
      @discount = discount / 100.0
      
      @reservations = []
    end
  end
end

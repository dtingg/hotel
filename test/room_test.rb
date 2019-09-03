require_relative "test_helper"

describe "Room class" do
  describe "Initialize method" do
    it "Creates an instance of Room" do
      room = Hotel::Room.new(1)
      
      expect(room).must_be_kind_of Hotel::Room
    end    
    
    it "Keeps track of id" do
      room = Hotel::Room.new(5)
      
      expect(room).must_respond_to :id
      expect(room.id).must_equal 5
    end
    
    it "Can have an id between 1 and 20" do
      expect(Hotel::Room.new(1).id).must_equal 1
      expect(Hotel::Room.new(20).id).must_equal 20
    end
    
    it "Raises an ArgumentError if id is outside of 1 - 20" do
      expect{Hotel::Room.new(0)}.must_raise ArgumentError
      expect{Hotel::Room.new(21)}.must_raise ArgumentError
    end
    
    it "Has a default nightly cost" do
      room = Hotel::Room.new(1)
      
      expect(room.nightly_cost).must_equal 200
    end
    
    it "Has a default empty array of reservations" do
      room = Hotel::Room.new(1)
      
      expect(room.reservations).must_be_kind_of Array
      expect(room.reservations).must_equal []
    end
  end
  
  describe "Self.all method" do
    it "Returns an array of 20 room objects" do
      all_rooms = Hotel::Room.all
      
      expect(all_rooms).must_be_kind_of Array
      expect(all_rooms.length).must_equal 20
      
      all_rooms.each do |room|
        expect(room).must_be_kind_of Hotel::Room
      end
      
      expect(all_rooms.first.id).must_equal 1
      expect(all_rooms.last.id).must_equal 20      
    end
  end
end

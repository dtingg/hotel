require_relative "test_helper"

describe "Room class" do
  describe "Initialize method" do
    it "Creates an instance of Room" do
      room = Hotel::Room.new(1)
      
      expect(room).must_be_kind_of Hotel::Room
    end    
    
    it "Keeps track of id" do
      room = Hotel::Room.new(1)
      
      expect(room).must_respond_to :id
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
end

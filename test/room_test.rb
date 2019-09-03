require_relative "test_helper"

describe "Room class" do
  describe "Initialize method" do
    it "Creates an instance of Room" do
      room = Hotel::Room.new(1)
      
      expect(room).must_be_kind_of Hotel::Room
    end    
  end
end

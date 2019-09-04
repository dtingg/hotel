require_relative "test_helper"

describe "RoomBlock class" do
  describe "initialize method" do
    it "Creates an instance of RoomBlock" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019")
      
      expect(block).must_be_kind_of Hotel::RoomBlock
    end
    
    it "Keeps track of name" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019")
      
      expect(block).must_respond_to :name
      expect(block.name).must_equal "Smith"
    end
    
    it "Keeps track of check_in" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019")
      
      expect(block).must_respond_to :check_in
      expect(block.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019")
      
      expect(block).must_respond_to :check_out
      expect(block.check_out).must_equal Date.parse("August 5, 2019")
    end
  end
end

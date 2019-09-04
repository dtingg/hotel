require_relative "test_helper"

describe "RoomBlock class" do
  describe "initialize method" do
    it "Creates an instance of RoomBlock" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 3, 50)
      
      expect(block).must_be_kind_of Hotel::RoomBlock
    end
    
    it "Keeps track of name" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 3, 50)
      
      expect(block).must_respond_to :name
      expect(block.name).must_equal "Smith"
    end
    
    it "Keeps track of check_in" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 3, 50)
      
      expect(block).must_respond_to :check_in
      expect(block.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 3, 50)
      
      expect(block).must_respond_to :check_out
      expect(block.check_out).must_equal Date.parse("August 5, 2019")
    end
    
    it "Keeps track of num_rooms" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 3, 50)
      
      expect(block).must_respond_to :num_rooms
      expect(block.num_rooms).must_equal 3
    end
    
    it "Can have 1 - 5 rooms" do
      block1 = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 1, 50)
      block2 = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 5, 50)
      
      expect(block1.num_rooms).must_equal 1
      expect(block2.num_rooms).must_equal 5
    end
    
    it "Throws an error if rooms is under 1 or over 5" do
      expect { Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 0, 50) }.must_raise ArgumentError
      expect { Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 6, 50) }.must_raise ArgumentError
    end
    
    it "Keeps track of discount" do
      block = Hotel::RoomBlock.new("Smith", "August 1, 2019", "August 5, 2019", 3, 50)
      
      expect(block).must_respond_to :discount
      expect(block.discount).must_equal 0.50
    end
    
    
  end
end

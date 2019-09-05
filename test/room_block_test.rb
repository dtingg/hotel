require_relative "test_helper"

describe "RoomBlock class" do
  let (:room1) { Hotel::Room.new(1) }
  let (:room2) { Hotel::Room.new(2) }
  let (:room3) { Hotel::Room.new(3) }
  let (:room4) { Hotel::Room.new(4) }
  let (:room5) { Hotel::Room.new(5) }
  let (:block) { Hotel::RoomBlock.new(
  name: "Wright", check_in: "August 1, 2019", check_out: "August 5, 2019", num_rooms: 3, discount: 50) }
  
  describe "initialize method" do    
    it "Creates an instance of RoomBlock" do
      expect(block).must_be_kind_of Hotel::RoomBlock
    end
    
    it "Keeps track of name" do
      expect(block).must_respond_to :name
      expect(block.name).must_equal "Wright"
    end
    
    it "Keeps track of check_in" do
      expect(block).must_respond_to :check_in
      expect(block.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      expect(block).must_respond_to :check_out
      expect(block.check_out).must_equal Date.parse("August 5, 2019")
    end
    
    it "Throws an error if check_in is after check_out" do
      check_in = "August 5, 2019"
      check_out = "August 1, 2019"
      
      expect { Hotel::RoomBlock.new(
      name: "Wright", check_in: check_in, check_out: check_out, num_rooms: 3, discount: 50) }.must_raise ArgumentError
    end
    
    it "Keeps track of num_rooms" do
      expect(block).must_respond_to :num_rooms
      expect(block.num_rooms).must_equal 3
    end
    
    it "Can have 1 - 5 rooms" do
      block1 = Hotel::RoomBlock.new(
      name: "Wright", check_in: "August 1, 2019", check_out: "August 5, 2019", num_rooms: 1, discount: 50)
      
      block2 = Hotel::RoomBlock.new(
      name: "Wright", check_in: "August 1, 2019", check_out: "August 5, 2019", num_rooms: 5, discount: 50)
      
      expect(block1.num_rooms).must_equal 1
      expect(block2.num_rooms).must_equal 5
    end
    
    it "Throws an error if rooms is outside of 1 - 5" do
      expect { Hotel::RoomBlock.new(
      name: "Smith", check_in: "August 1, 2019", check_out: "August 5, 2019", num_rooms: 0, discount: 50
      ) }.must_raise ArgumentError
      
      expect { Hotel::RoomBlock.new(
      name: "Smith", check_in: "August 1, 2019", check_out: "August 5, 2019", num_rooms: 6, discount: 50
      ) }.must_raise ArgumentError
    end
    
    it "Keeps track of discount" do
      expect(block).must_respond_to :discount
      expect(block.discount).must_equal 0.50
    end
    
    it "Keeps track of reservations" do
      expect(block).must_respond_to :reservations
      expect(block.reservations).must_be_kind_of Array
      
      block.reservations.each do |reservation|
        expect(reservation).must_be_kind_of Hotel::Reservation
      end
    end
  end
end

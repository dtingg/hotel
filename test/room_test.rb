require_relative "test_helper"

describe "Room class" do
  let (:room) { Hotel::Room.new(1) }
  
  describe "initialize method" do
    it "Creates an instance of Room" do
      expect(room).must_be_kind_of Hotel::Room
    end    
    
    it "Keeps track of id" do
      expect(room).must_respond_to :id
      expect(room.id).must_equal 1
    end
    
    it "Can have an id between 1 and 20" do
      expect(room.id).must_equal 1
      expect(Hotel::Room.new(20).id).must_equal 20
    end
    
    it "Raises an ArgumentError if id is outside of 1 - 20" do
      expect{ Hotel::Room.new(0) }.must_raise ArgumentError
      expect{ Hotel::Room.new(21) }.must_raise ArgumentError
    end
    
    it "Has a default nightly cost" do
      expect(room.nightly_cost).must_equal 200
    end
    
    it "Has a default empty array of reservations" do
      expect(room.reservations).must_be_kind_of Array
      expect(room.reservations).must_equal []
    end
  end
  
  describe "change_cost method" do
    it "Changes the nightly cost" do
      room.change_cost(500)
      
      expect(room.nightly_cost).must_equal 500
    end
  end
  
  describe "add_reservation method" do
    it "Adds a reservation to the reservations array" do
      reservation = Hotel::Reservation.new(id: 1, room: room, check_in: "August 1, 2019", check_out: "August 5, 2019")
      room.add_reservation(reservation)
      
      expect(room.reservations.length).must_equal 1
      expect(room.reservations.include?(reservation)).must_equal true
    end
  end
  
  describe "self.all method" do
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

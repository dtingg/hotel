require_relative "test_helper"

describe "Reservation class" do
  describe "initialize method" do
    it "Creates an instance of Reservation" do
      reservation = Hotel::Reservation.new(1, 5, "August 1, 2019", "August 5, 2019")
      
      expect(reservation).must_be_kind_of Hotel::Reservation
    end
    
    it "Keeps track of id" do
      reservation = Hotel::Reservation.new(1, 5, "August 1, 2019", "August 5, 2019")
      
      expect(reservation).must_respond_to :id
      expect(reservation.id).must_equal 1
    end
    
    it "Keeps track of room" do
      reservation = Hotel::Reservation.new(1, 5, "August 1, 2019", "August 5, 2019")
      
      expect(reservation).must_respond_to :room
      expect(reservation.room).must_equal 5
    end
    
    it "Keeps track of check_in" do
      reservation = Hotel::Reservation.new(1, 5, "August 1, 2019", "August 5, 2019")
      
      expect(reservation).must_respond_to :check_in
      expect(reservation.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      reservation = Hotel::Reservation.new(1, 5, "August 1, 2019", "August 5, 2019")
      
      expect(reservation).must_respond_to :check_out
      expect(reservation.check_out).must_equal Date.parse("August 5, 2019")
    end
    
    it "Throws an error if check_in is after check_out" do
      check_in = "August 5, 2019"
      check_out = "August 1, 2019"
      
      expect { Hotel::Reservation.new(1, 5, check_in, check_out) }.must_raise ArgumentError
    end
  end  
  
  describe "total_cost method" do
    it "Returns the cost for a reservation" do
      room = Hotel::Room.new(5)
      reservation = Hotel::Reservation.new(1, room, "August 1, 2019", "August 5, 2019")
      
      expect(reservation.total_cost).must_equal 800
    end
  end
end

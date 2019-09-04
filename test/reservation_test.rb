require_relative "test_helper"

describe "Reservation class" do
  let (:room5) { Hotel::Room.new(5)}
  let (:reservation) { Hotel::Reservation.new(1, room5, "August 1, 2019", "August 5, 2019") }
  
  describe "initialize method" do
    it "Creates an instance of Reservation" do
      expect(reservation).must_be_kind_of Hotel::Reservation
    end
    
    it "Keeps track of id" do
      expect(reservation).must_respond_to :id
      expect(reservation.id).must_equal 1
    end
    
    it "Keeps track of room" do
      expect(reservation).must_respond_to :room
      expect(reservation.room).must_equal room5
    end
    
    it "Keeps track of check_in" do
      expect(reservation).must_respond_to :check_in
      expect(reservation.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      expect(reservation).must_respond_to :check_out
      expect(reservation.check_out).must_equal Date.parse("August 5, 2019")
    end
    
    it "Keeps track of status" do
      expect(reservation).must_respond_to :status
    end
    
    it "Has a default status of :CONFIRMED" do
      expect(reservation.status).must_equal :CONFIRMED
    end
    
    it "Keeps track of discount" do
      reservation = Hotel::Reservation.new(1, room5, "August 1, 2019", "August 5, 2019", :HOLD, 0.25)
      
      expect(reservation).must_respond_to :discount
      expect(reservation.discount).must_equal 0.25
    end
    
    it "Sets a default discount of nil" do
      assert_nil(reservation.discount)
    end
    
    it "Throws an error if check_in is after check_out" do
      check_in = "August 5, 2019"
      check_out = "August 1, 2019"
      
      expect { Hotel::Reservation.new(1, room5, check_in, check_out) }.must_raise ArgumentError
    end
  end  
  
  describe "total_cost method" do
    it "Returns the cost for a reservation" do
      expect(reservation.total_cost).must_equal 800
    end
    
    it "Returns the correct cost if there is a discount" do
      room = Hotel::Room.new(5)
      reservation = Hotel::Reservation.new(1, room, "August 1, 2019", "August 5, 2019", :HOLD, 0.50)
      
      expect(reservation.total_cost).must_equal 400
    end
  end
end

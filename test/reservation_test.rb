require_relative "test_helper"

describe "Reservation class" do
  let (:room) { Hotel::Room.new(1)}
  let (:reservation) { Hotel::Reservation.new(
  id: 1, room: room, check_in: "August 1, 2019", check_out: "August 5, 2019"
  ) }
  
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
      expect(reservation.room).must_equal room
    end
    
    it "Keeps track of check_in" do
      expect(reservation).must_respond_to :check_in
      expect(reservation.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      expect(reservation).must_respond_to :check_out
      expect(reservation.check_out).must_equal Date.parse("August 5, 2019")
    end
    
    it "Throws an error if check_in is after check_out" do
      check_in = "August 5, 2019"
      check_out = "August 1, 2019"
      
      expect { Hotel::Reservation.new(id: 1, room: room, check_in: check_in, check_out: check_out) }.must_raise ArgumentError
    end
    
    it "Keeps track of status" do
      expect(reservation).must_respond_to :status
    end
    
    it "Has a default status of :CONFIRMED" do
      expect(reservation.status).must_equal :CONFIRMED
    end
    
    it "Keeps track of discount" do
      reservation = Hotel::Reservation.new(
      id: 1, room: room, check_in: "August 1, 2019", check_out: "August 5, 2019", status: :HOLD, discount: 0.25)
      
      expect(reservation).must_respond_to :discount
      expect(reservation.discount).must_equal 0.25
    end
    
    it "Sets a default discount of nil" do
      assert_nil(reservation.discount)
    end
  end  
  
  describe "total_cost method" do
    it "Returns the cost for a reservation" do
      expect(reservation.total_cost).must_equal 800
    end
    
    it "Returns the correct cost if there is a discount" do
      reservation = Hotel::Reservation.new(
      id: 1, room: room, check_in: "August 1, 2019", check_out: "August 5, 2019", status: :CONFIRMED, discount: 0.50)
      
      expect(reservation.total_cost).must_equal 400
    end
  end
end

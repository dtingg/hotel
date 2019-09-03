require_relative "test_helper"

describe "Reservation class" do
  describe "Initialize method" do
    it "Creates an instance of Reservation" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 5, 2019")
      
      expect(reservation).must_be_kind_of Hotel::Reservation
    end
    
    it "Keeps track of id" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 5, 2019")
      
      expect(reservation).must_respond_to :id
      expect(reservation.id).must_equal 1
    end
    
    it "Keeps track of room" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 5, 2019")
      
      expect(reservation).must_respond_to :room
      expect(reservation.room).must_equal 5
    end
    
    it "Keeps track of check_in" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 5, 2019")
      
      expect(reservation).must_respond_to :check_in
      expect(reservation.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check_out" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 5, 2019")
      
      expect(reservation).must_respond_to :check_out
      expect(reservation.check_out).must_equal Date.parse("August 5, 2019")
    end
  end  
end

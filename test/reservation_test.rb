require_relative "test_helper"

describe "Reservation class" do
  describe "Initialize method" do
    it "Creates an instance of Reservation" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 2, 2019")
      
      expect(reservation).must_be_kind_of Hotel::Reservation
    end
    
    it "Keeps track of id" do
      reservation = Hotel::Reservation.new(id: 1, room: 5, check_in: "August 1, 2019", check_out: "August 2, 2019")
      
      expect(reservation).must_respond_to :id
      expect(reservation.id).must_equal 1
    end
  end  
end

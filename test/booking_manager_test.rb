require_relative "test_helper"

describe "BookingManager class" do
  describe "Initialize method" do
    it "Creates an instance of BookingManager" do
      manager = Hotel::BookingManager.new
      
      expect(manager).must_be_kind_of Hotel::BookingManager
    end
    
    it "Responds to all_rooms" do
      manager = Hotel::BookingManager.new
      
      expect(manager).must_respond_to :all_rooms
      expect(manager.all_rooms).must_be_kind_of Array
      expect(manager.all_rooms.length).must_equal 20
    end
    
    it "Responds to reservations" do
      manager = Hotel::BookingManager.new
      
      expect(manager).must_respond_to :all_reservations
      expect(manager.all_reservations).must_be_kind_of Array
      expect(manager.all_reservations).must_equal []
    end  
  end
  
  describe "Make reservation method" do
    it "Creates a reservation" do
      manager = Hotel::BookingManager.new
      
      reservation = manager.make_reservation("August 10, 2019", "August 12, 2019")
      
      expect(reservation).must_be_kind_of Hotel::Reservation
    end
  end
end

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
  
  describe "Find reservations method" do
    it "Finds reservations for a particular date" do
      manager = Hotel::BookingManager.new
      
      manager.make_reservation("August 15, 2019", "August 16, 2019") 
      manager.make_reservation("August 10, 2019", "August 11, 2019") 
      manager.make_reservation("August 12, 2019", "August 20, 2019") 
      manager.make_reservation("August 10, 2019", "August 12, 2019") 
      
      date = "August 10, 2019"
      
      august_10_reservations = manager.find_reservations(date)
      
      expect(august_10_reservations).must_be_kind_of Array
      expect(august_10_reservations.length).must_equal 2
      
      august_10_reservations.each do |reservation|
        reservation.must_be_kind_of Hotel::Reservation
        reservation.check_in.must_equal Date.parse(date)
      end
    end    
  end
end

require_relative "test_helper"

describe "BookingManager class" do
  describe "initialize method" do
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
  
  describe "view_available_rooms method" do
    it "Returns 20 available rooms when no rooms are booked" do
      manager = Hotel::BookingManager.new
      
      rooms = manager.view_available_rooms("August 5, 2019", "August 8, 2019")
      
      expect(rooms.length).must_equal 20
    end
    
    it "Returns 19 available rooms when one room is booked" do
      manager = Hotel::BookingManager.new
      manager.make_reservation("August 10, 2019", "August 12, 2019")
      
      rooms = manager.view_available_rooms("August 10, 2019", "August 12, 2019")
      
      expect(rooms.length).must_equal 19
    end    
  end
  
  describe "make_reservation method" do
    it "Creates a reservation" do
      manager = Hotel::BookingManager.new
      
      reservation = manager.make_reservation("August 10, 2019", "August 12, 2019")
      
      expect(reservation).must_be_kind_of Hotel::Reservation
    end
  end
  
  describe "find_reservations method" do
    it "Finds reservations for a particular date" do
      manager = Hotel::BookingManager.new
      
      manager.make_reservation("August 10, 2019", "August 12, 2019")
      manager.make_reservation("August 12, 2019", "August 20, 2019")
      manager.make_reservation("August 10, 2019", "August 15, 2019")
      manager.make_reservation("August 12, 2019", "August 14, 2019")
      manager.make_reservation("August 15, 2019", "August 16, 2019")
      
      date = "August 12, 2019"
      august_12_reservations = manager.find_reservations(date)
      
      expect(august_12_reservations).must_be_kind_of Array
      expect(august_12_reservations.length).must_equal 3
      
      august_12_reservations.each do |reservation|
        reservation.must_be_kind_of Hotel::Reservation
      end
    end    
  end
end

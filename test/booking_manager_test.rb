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
end

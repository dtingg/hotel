require_relative "test_helper"

describe "BookingManager class" do
  let (:manager) { Hotel::BookingManager.new }
  let (:room1) { manager.all_rooms.find { |room| room.id == 1} }
  let (:room2) { manager.all_rooms.find { |room| room.id == 2} }
  let (:room3) { manager.all_rooms.find { |room| room.id == 3} }
  
  describe "initialize method" do
    it "Creates an instance of BookingManager" do
      expect(manager).must_be_kind_of Hotel::BookingManager
    end
    
    it "Responds to all_rooms" do
      expect(manager).must_respond_to :all_rooms
      expect(manager.all_rooms).must_be_kind_of Array
      expect(manager.all_rooms.length).must_equal 20
    end
    
    it "Responds to all_reservations" do
      expect(manager).must_respond_to :all_reservations
      expect(manager.all_reservations).must_be_kind_of Array
      expect(manager.all_reservations).must_equal []
    end  
    
    it "Responds to all_blocks" do
      expect(manager).must_respond_to :all_blocks
      expect(manager.all_blocks).must_be_kind_of Array
      expect(manager.all_blocks).must_equal []
    end  
  end
  
  describe "room_available? method" do
    it "Returns true if a room is available, otherwise it returns false" do
      manager.make_reservation(check_in: "May 1, 2019", check_out: "May 5, 2019")
      manager.make_reservation(check_in: "May 8, 2019", check_out: "May 10, 2019")
      manager.make_reservation(check_in: "May 15, 2019", check_out: "May 20, 2019")
      
      expect(manager.room_available?(check_in: "April 30, 2019", check_out: "May 1, 2019", room: room1)).must_equal true 
      expect(manager.room_available?(check_in: "May 1, 2019", check_out: "May 2, 2019", room: room1)).must_equal false
      expect(manager.room_available?(check_in: "May 5, 2019", check_out: "May 8, 2019", room: room1)).must_equal true
      expect(manager.room_available?(check_in: "May 17, 2019", check_out: "May 18, 2019", room: room1)).must_equal false
      expect(manager.room_available?(check_in: "May 20, 2019", check_out: "May 21, 2019", room: room1)).must_equal true
    end
  end
  
  describe "available_rooms method" do
    it "Returns 20 available rooms when no rooms are booked" do
      rooms = manager.available_rooms(check_in: "August 5, 2019", check_out: "August 8, 2019")
      
      expect(rooms.length).must_equal 20
    end
    
    it "Returns 19 available rooms when one room is booked" do
      manager.make_reservation(check_in: "August 9, 2019", check_out: "August 12, 2019")
      
      rooms = manager.available_rooms(check_in: "August 10, 2019", check_out: "August 12, 2019")
      
      expect(rooms.length).must_equal 19
    end    
    
    it "Returns 20 available rooms if new reservation doesn't conflict with existing reservation" do
      manager.make_reservation(check_in: "August 9, 2019", check_out: "August 12, 2019")
      
      rooms = manager.available_rooms(check_in: "August 12, 2019", check_out: "August 14, 2019")
      
      expect(rooms.length).must_equal 20
    end
  end
  
  describe "make_reservation method" do
    it "Creates a reservation" do
      reservation = manager.make_reservation(check_in: "August 10, 2019", check_out: "August 12, 2019")
      
      expect(reservation).must_be_kind_of Hotel::Reservation
      expect(manager.all_reservations.include?(reservation)).must_equal true
      expect(reservation.room.reservations.include?(reservation)).must_equal true
    end
    
    it "Raises an error if there are no rooms available" do
      20.times do
        manager.make_reservation(check_in: "August 1, 2019", check_out: "August 2, 2019")
      end
      
      expect { manager.make_reservation(check_in: "August 1, 2019", check_out: "August 2, 2019") }.must_raise ArgumentError
    end
  end
  
  describe "make_block method" do
    it "Creates a block reservation" do
      block = manager.make_block(name: "Tingg", check_in: "August 5", check_out: "August 10", num_rooms: 3, discount: 50) 
      
      expect(block).must_be_kind_of Hotel::RoomBlock
      expect(manager.all_blocks.include?(block)).must_equal true
    end
    
    it "Throws an error if not enough rooms are available" do
      manager.make_block(name: "Blair", check_in: "August 5", check_out: "August 10", num_rooms: 5, discount: 50)
      manager.make_block(name: "Leavitt", check_in: "August 5", check_out: "August 10", num_rooms: 5, discount: 50)
      manager.make_block(name: "Johns", check_in: "August 5", check_out: "August 10", num_rooms: 5, discount: 50)
      manager.make_block(name: "Tingg", check_in: "August 5", check_out: "August 10", num_rooms: 5, discount: 50)
      
      expect{ manager.make_block(
      name: "Wright", check_in: "August 5", check_out: "August 10", num_rooms: 3, discount: 50) }.must_raise ArgumentError
    end
    
    it "Throws an error if check_in date is after check_out date" do
      expect{ manager.make_block(
      name: "Tingg", check_in: "August 15", check_out: "August 10", num_rooms: 3, discount: 50) }.must_raise ArgumentError
    end
    
    it "Makes single reservations for each room in the block" do
      manager.make_block(name: "Tingg", check_in: "August 5", check_out: "August 10", num_rooms: 3, discount: 50)
      
      expect(manager.all_reservations.length).must_equal 3
      expect(room1.reservations.length).must_equal 1
      expect(room2.reservations.length).must_equal 1
      expect(room3.reservations.length).must_equal 1
    end
  end
  
  describe "find_reservations method" do
    it "Finds confirmed reservations for a particular date" do      
      manager.make_reservation(check_in: "August 10, 2019", check_out: "August 12, 2019", status: :CONFIRMED)
      manager.make_reservation(check_in: "August 12, 2019", check_out: "August 20, 2019", status: :CONFIRMED)
      manager.make_reservation(check_in: "August 10, 2019", check_out: "August 15, 2019", status: :CONFIRMED)
      manager.make_reservation(check_in: "August 12, 2019", check_out: "August 14, 2019", status: :HOLD)
      manager.make_reservation(check_in: "August 15, 2019", check_out: "August 16, 2019", status: :CONFIRMED)
      
      date = "August 12, 2019"
      
      august_12_reservations = manager.find_reservations(date)
      
      expect(august_12_reservations).must_be_kind_of Array
      expect(august_12_reservations.length).must_equal 2
      
      august_12_reservations.each do |reservation|
        reservation.must_be_kind_of Hotel::Reservation
      end
    end 
  end
end

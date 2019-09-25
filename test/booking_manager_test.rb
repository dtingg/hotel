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
  
  describe "find_room method" do
    it "Finds the correct room by ID" do
      room = manager.find_room(5)
      
      expect(room.id).must_equal 5
    end
  end
  
  describe "find_reservation method" do
    it "Find the correct reservation by ID" do
      manager.make_reservation(check_in: "August 9, 2019", check_out: "August 12, 2019")
      reservation = manager.find_reservation(1)
      
      expect(reservation.id).must_equal 1
    end
  end
  
  describe "change_room_cost method" do
    it "Allows you to change a room's cost" do
      room5 = manager.find_room(5)
      manager.change_room_cost(room_num: 5, new_cost: 100)
      
      expect(room5.nightly_cost).must_equal 100
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
      block = manager.make_block(
        name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50
      )
      
      expect(block).must_be_kind_of Hotel::RoomBlock
      expect(manager.all_blocks.include?(block)).must_equal true
    end
    
    it "Throws an error if not enough rooms are available" do
      manager.make_block(name: "Blair", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 5, discount: 50)
      manager.make_block(name: "Leavitt", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 5, discount: 50)
      manager.make_block(name: "Johns", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 5, discount: 50)
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 5, discount: 50)
      
      expect{ 
        manager.make_block(
          name: "Wright", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50
        ) 
      }.must_raise ArgumentError
    end
    
    it "Throws an error if check_in date is after check_out date" do
      expect{ 
        manager.make_block(
          name: "Tingg", check_in: "August 15, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50
        ) 
      }.must_raise Hotel::CheckInDateError
    end
    
    it "Throws an error if there is already a block under that name" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 5, discount: 50)
      
      expect{ 
        manager.make_block(
          name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50
        ) 
      }.must_raise ArgumentError
    end
    
    it "Makes single reservations for each room in the block" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      
      expect(manager.all_reservations.length).must_equal 3
      expect(room1.reservations.length).must_equal 1
      expect(room2.reservations.length).must_equal 1
      expect(room3.reservations.length).must_equal 1
    end
  end
  
  describe "find_block method" do
    it "Finds the correct block reservation" do
      manager.make_block(name: "Wright", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      
      block = manager.find_block("Tingg")
      
      expect(block.name).must_equal "Tingg"
    end
  end
  
  describe "make_block_reservation method" do
    it "Allows you to confirm a reservation in a block" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      reservation1 = manager.make_block_reservation("Tingg")
      
      expect(reservation1.status).must_equal :CONFIRMED      
    end
    
    it "Throws an error if there are no reservations left in a block" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      
      3.times do
        manager.make_block_reservation("Tingg")
      end
      
      expect{ manager.make_block_reservation("Tingg") }.must_raise ArgumentError
    end
  end
  
  describe "find_day_reservations method" do
    it "Finds confirmed reservations for a particular date" do      
      manager.make_reservation(check_in: "August 10, 2019", check_out: "August 12, 2019", status: :CONFIRMED)
      manager.make_reservation(check_in: "August 12, 2019", check_out: "August 20, 2019", status: :CONFIRMED)
      manager.make_reservation(check_in: "August 10, 2019", check_out: "August 15, 2019", status: :CONFIRMED)
      manager.make_reservation(check_in: "August 12, 2019", check_out: "August 14, 2019", status: :HOLD)
      manager.make_reservation(check_in: "August 15, 2019", check_out: "August 16, 2019", status: :CONFIRMED)
      
      date = "August 12, 2019"
      
      august_12_reservations = manager.find_day_reservations(date)
      
      expect(august_12_reservations).must_be_kind_of Array
      expect(august_12_reservations.length).must_equal 2
      
      august_12_reservations.each do |reservation|
        reservation.must_be_kind_of Hotel::Reservation
      end
    end
    
    it "Shows confirmed reservations under a room block" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      2.times do 
        manager.make_block_reservation("Tingg")
      end
      
      expect(manager.find_day_reservations("August 5, 2019").length).must_equal 2
    end
  end 
  
  describe "save_rooms method" do
    it "Saves all rooms to a csv file" do
      manager.change_room_cost(room_num: 1, new_cost: 100)
      manager.change_room_cost(room_num: 2, new_cost: 50)
      manager.make_reservation(check_in: "August 1, 2019", check_out: "August 4, 2019")
      manager.make_reservation(check_in: "August 5, 2019", check_out: "August 10, 2019")
      manager.make_reservation(check_in: "August 1, 2019", check_out: "August 4, 2019")
      manager.save_rooms("./test/save_rooms.csv")
      
      expected_csv = 
      "id,nightly_cost,reservations\n" \
      "1,100,1;2\n2,50,3\n3,200,\n4,200,\n5,200,\n" \
      "6,200,\n7,200,\n8,200,\n9,200,\n10,200,\n" \
      "11,200,\n12,200,\n13,200,\n14,200,\n15,200,\n" \
      "16,200,\n17,200,\n18,200,\n19,200,\n20,200,\n"
      
      actual_csv = File.open("./test/save_rooms.csv").read
      
      expect(expected_csv == actual_csv).must_equal true
    end
  end
  
  describe "save_reservations method" do
    it "Saves all hotel reservations to a csv file" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      manager.make_block_reservation("Tingg")
      manager.make_reservation(check_in: "August 5, 2019", check_out: "August 10, 2019")
      manager.save_reservations("./test/save_reservations.csv")
      
      expected_csv = 
      "id,room,check_in,check_out,status,discount\n" \
      "1,1,2019-08-05,2019-08-10,CONFIRMED,0.5\n" \
      "2,2,2019-08-05,2019-08-10,HOLD,0.5\n" \
      "3,3,2019-08-05,2019-08-10,HOLD,0.5\n" \
      "4,4,2019-08-05,2019-08-10,CONFIRMED,\n"
      
      actual_csv = File.open("./test/save_reservations.csv").read
      
      expect(expected_csv == actual_csv).must_equal true 
    end
  end
  
  describe "save_blocks method" do
    it "Saves all blocks to a csv file" do
      manager.make_block(name: "Tingg", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      manager.make_block(name: "Wright", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 50)
      manager.make_block(name: "Blair", check_in: "August 5, 2019", check_out: "August 10, 2019", num_rooms: 3, discount: 25)
      manager.save_blocks("./test/save_blocks.csv")
      
      expected_csv = 
      "name,check_in,check_out,num_rooms,discount,reservations\n" \
      "Tingg,2019-08-05,2019-08-10,3,50.0,1;2;3\n" \
      "Wright,2019-08-05,2019-08-10,3,50.0,4;5;6\n" \
      "Blair,2019-08-05,2019-08-10,3,25.0,7;8;9\n"
      
      actual_csv = File.open("./test/save_blocks.csv").read
      
      expect(expected_csv == actual_csv).must_equal true
    end
  end
  
  describe "load_files method" do
    it "Loads data from csv files" do
      manager.load_files("test/load_rooms.csv", "test/load_reservations.csv", "test/load_blocks.csv")
      
      expect(manager.all_rooms.length).must_equal 20
      expect(manager.all_rooms.first.id).must_equal 1
      expect(manager.all_rooms.last.nightly_cost).must_equal 300
      expect(manager.all_rooms.first.reservations.length).must_equal 2
      expect(manager.all_rooms.first.reservations.first).must_be_kind_of Hotel::Reservation
      expect(manager.all_rooms.first.reservations.first.id).must_equal 1
      expect(manager.all_rooms.last.reservations).must_equal []
      
      expect(manager.all_reservations.length).must_equal 8
      expect(manager.all_reservations.first).must_be_kind_of Hotel::Reservation
      expect(manager.all_reservations.first.id).must_equal 1
      expect(manager.all_reservations.first.room.id).must_equal 1
      expect(manager.all_reservations.first.check_in).must_be_kind_of Date
      expect(manager.all_reservations.first.status).must_equal :CONFIRMED
      expect(manager.all_reservations.first.discount).must_equal 0.2
      
      expect(manager.all_blocks.length).must_equal 2
      expect(manager.all_blocks.first.name).must_equal "Tingg"
      expect(manager.all_blocks.first.check_in).must_be_kind_of Date
      expect(manager.all_blocks.first.num_rooms).must_equal 3
      expect(manager.all_blocks.first.reservations.first.discount).must_equal 0.2
      expect(manager.all_blocks.first.reservations.length).must_equal 3
      expect(manager.all_blocks.first.reservations.first).must_be_kind_of Hotel::Reservation
      expect(manager.all_blocks.first.reservations.first.id).must_equal 1
    end
  end
end

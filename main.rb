require "date"
require "csv"

require_relative "lib/booking_manager"
require_relative "lib/reservation"
require_relative "lib/room_block"
require_relative "lib/room"

def print_menu
  puts "\nMAIN MENU"
  
  menu_options = [
    "List rooms", 
    "Change a room price",
    "Make a reservation", 
    "Make a block reservation", 
    "Confirm a block reservation", 
    "Save data to file", 
    "Load data from file", 
    "Exit"
  ]
  
  menu_options.each_with_index do |option, index|
    puts "#{index + 1}. #{option}"
  end
end

def main
  manager = Hotel::BookingManager.new
  
  puts "Welcome to Dianna's Hotel Program"
  
  play = true
  
  while play
    print_menu
    
    print "\nPlease choose a menu number: "
    answer = gets.chomp.to_i
    
    until (1..8).include?(answer)
      print "Please enter a valid option: "
      answer = gets.chomp.to_i
    end
    
    case answer
    when 1
      puts "\nALL HOTEL ROOMS"
      manager.all_rooms.each do |room|
        print "Room #{room.id}, Nightly Cost: $#{"%.2f" % room.nightly_cost}\n"
      end
      
    when 2
      print "Which room would you like to change?: "
      room_num = gets.chomp.to_i
      
      until room_num > 0 && room_num < 21
        print "Please enter a valid room number: "
        room_num = gets.chomp.to_i
      end
      
      print "What is the new nightly cost? "
      new_cost = gets.chomp.to_f
      
      manager.change_room_cost(room_num: room_num, new_cost: new_cost)
      
      puts "\nRoom #{room_num} now has a nightly cost of $#{"%.2f" % new_cost}."
      
    when 3
      print "Check in date: "
      check_in = gets.chomp
      
      print "Check out date: "
      check_out = gets.chomp
      
      reservation = manager.make_reservation(check_in: check_in, check_out: check_out)
      
      puts "\nHere is your confirmed reservation:"
      puts "  Reservation Number: #{reservation.id}"
      puts "  Room Number: #{reservation.room.id}"
      puts "  Nightly cost: $#{"%.2f" % reservation.room.nightly_cost}"
      puts "  Check in: #{reservation.check_in}"
      puts "  Check out: #{reservation.check_out}"
      puts "  Total cost: $#{"%.2f" % reservation.total_cost}"
      puts "  Status: #{reservation.status}"
      
    when 4
      print "Party name: "
      name = gets.chomp
      
      print "Check in date: "
      check_in = gets.chomp
      
      print "Check out date: "
      check_out = gets.chomp
      
      print "Number of rooms (1 - 5): "
      num_rooms = gets.chomp.to_i
      
      while num_rooms <= 0 || num_rooms > 5
        print "Please enter a valid number of rooms (1 - 5): "
        num_rooms = gets.chomp.to_i
      end
      
      print "Discount percentage (50 for 50%): "
      discount = gets.chomp.to_i
      
      block = manager.make_block(name: name, check_in: check_in, check_out: check_out, num_rooms: num_rooms, discount: discount)
      
      puts "\nHere are your room block details: "
      puts "  Name: #{block.name}"
      puts "  Check in: #{block.check_in}"
      puts "  Check out: #{block.check_out}"
      puts "  Number of rooms: #{block.num_rooms}"
      puts "  Discount: #{(block.discount * 100).to_i}%"
      
    when 5
      print "Party name: "
      name = gets.chomp
      
      reservation = manager.make_block_reservation(name)
      
      puts "\nHere is your confirmed reservation:"
      puts "  Reservation Number: #{reservation.id}"
      puts "  Room Number: #{reservation.room.id}"
      puts "  Check in: #{reservation.check_in}"
      puts "  Check out: #{reservation.check_out}"
      puts "  Total cost: $#{"%.2f" % reservation.total_cost}"
      puts "  Status: #{reservation.status}"
      
    when 6
      puts "Save data to file"
      
    when 7
      puts "Load data from file "
      
    when 8
      puts "\nGoodbye!"
      play = false    
    end
  end
end

main

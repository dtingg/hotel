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
      "print change a room price"
    when 3
      
      print "Check in date: "
      check_in = gets.chomp
      
      print "Check out date: "
      check_out = gets.chomp
      
      reservation = manager.make_reservation(check_in: check_in, check_out: check_out)
      
      puts "\nHere is your confirmed reservation:"
      puts "\tReservation Number: #{reservation.id}"
      puts "\tRoom Number: #{reservation.room.id}"
      puts "\tCheck in date: #{reservation.check_in}"
      puts "\tCheck out date: #{reservation.check_out}"
      puts "\tStatus: #{reservation.status}"
      
    when 4
      puts "Make a block reservation"
    when 5
      puts "Confirm a block reservation"
    when 6
      puts "Save data to file"
    when 7
      puts "Load data from file "
    when 8
      puts "Goodbye!"
      play = false    
    end
  end
end

main

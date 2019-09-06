require "date"
require "csv"

require_relative "lib/booking_manager"
require_relative "lib/reservation"
require_relative "lib/room_block"
require_relative "lib/room"

def print_menu
  puts "\nMAIN MENU"
  
  menu_options = ["Make a reservation", "Make a block reservation", "Exit"]
  
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
    
    until (1..3).include?(answer)
      print "Please enter a valid option: "
      answer = gets.chomp.to_i
    end
    
    case answer
    when 1
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
      
    when 2
      puts "Not done yet"
    when 3
      puts "Goodbye!"
      play = false    
    end
    
  end
end

main

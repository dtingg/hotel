require "date"
require "csv"

require_relative "lib/booking_manager"
require_relative "lib/reservation"
require_relative "lib/room_block"
require_relative "lib/room"

MANAGER = Hotel::BookingManager.new

def print_menu
  puts "\nMAIN MENU"
  
  menu_options = [
    "List rooms", 
    "Change a room price",
    "Make a reservation", 
    "Make a block reservation", 
    "Confirm a reservation under a block", 
    "List confirmed reservations by day",
    "Save data to file", 
    "Load data from file", 
    "Exit"
  ]
  
  menu_options.each_with_index do |option, index|
    puts "#{index + 1}. #{option}"
  end
end

def list_rooms
  puts "\nALL HOTEL ROOMS"
  MANAGER.all_rooms.each do |room|
    print "Room #{room.id}, Nightly Cost: $#{"%.2f" % room.nightly_cost}\n"
  end
end

def change_price
  print "Which room would you like to change?: "
  room_num = gets.chomp.to_i
  
  until room_num > 0 && room_num < 21
    print "Please enter a valid room number (1 - 20): "
    room_num = gets.chomp.to_i
  end
  
  print "What is the new nightly cost? "
  new_cost = gets.chomp.to_f
  
  until new_cost > 0
    print "Please enter a new nightly cost that is greater than 0: "
    new_cost = gets.chomp.to_f
  end
  
  MANAGER.change_room_cost(room_num: room_num, new_cost: new_cost)
  puts "\nRoom #{room_num} now has a nightly cost of $#{"%.2f" % new_cost}."
end

def make_reservation
  print "Check in date: "
  check_in = gets.chomp
  
  print "Check out date: "
  check_out = gets.chomp
  
  begin
    reservation = MANAGER.make_reservation(check_in: check_in, check_out: check_out)
  rescue ArgumentError
    puts "Those dates are invalid. Please try again."
    return
  end
  
  puts "\nHere is your confirmed reservation:"
  puts "  Reservation Number: #{reservation.id}"
  puts "  Room Number: #{reservation.room.id}"
  puts "  Nightly cost: $#{"%.2f" % reservation.room.nightly_cost}"
  puts "  Check in: #{reservation.check_in}"
  puts "  Check out: #{reservation.check_out}"
  puts "  Total cost: $#{"%.2f" % reservation.total_cost}"
  puts "  Status: #{reservation.status}"
end

def make_block
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
  
  print "Discount percentage (15 for 15%): "
  discount = gets.chomp.to_i
  
  while discount <= 0 || discount > 100
    print "Please enter a valid discount percentage (1 - 100): "
    discount = gets.chomp.to_i
  end
  
  begin
    block = MANAGER.make_block(name: name, check_in: check_in, check_out: check_out, num_rooms: num_rooms, discount: discount)
  rescue ArgumentError
    puts "Those dates are invalid. Please try again."
    return
  end
  
  puts "\nHere are your room block details: "
  puts "  Name: #{block.name}"
  puts "  Check in: #{block.check_in}"
  puts "  Check out: #{block.check_out}"
  puts "  Number of rooms: #{block.num_rooms}"
  puts "  Discount: #{(block.discount * 100).to_i}%"
end

def confirm_block
  print "Party name: "
  name = gets.chomp
  
  begin
    reservation = MANAGER.make_block_reservation(name)
  rescue NoMethodError
    puts "There is no block reservation under that name."
    return
  rescue ArgumentError
    puts "There are no more available rooms under that name."
    return
  end
  
  puts "\nHere is your confirmed reservation:"
  puts "  Reservation Number: #{reservation.id}"
  puts "  Room Number: #{reservation.room.id}"
  puts "  Check in: #{reservation.check_in}"
  puts "  Check out: #{reservation.check_out}"
  puts "  Total cost: $#{"%.2f" % reservation.total_cost}"
  puts "  Status: #{reservation.status}"
end

def daily_reservations
  print "Enter day: "
  day = gets.chomp
  
  begin
    day_reservations = MANAGER.find_day_reservations(day)  
  rescue ArgumentError
    puts "That day is not valid. Please try again."
    return
  end
  
  puts "\nRESERVATIONS FOR #{day.upcase}"
  day_reservations.each do |reservation|
    puts "Reservation: #{reservation.id}, Room: #{reservation.room.id}, Check In: #{reservation.check_in}, Check Out: #{reservation.check_out}"
  end
end

def save_data
  print "Please enter a filename for the reservations: "
  reservations_file = gets.chomp
  reservations_filename = reservations_file + ".csv"
  
  MANAGER.save_reservations(reservations_filename)
  
  print "Please enter a filename for the room blocks: "
  blocks_file = gets.chomp
  blocks_filename = blocks_file + ".csv"
  
  MANAGER.save_blocks(blocks_filename)
  
  puts "Your files were saved successfully."
end

def load_data
  print 'Please enter the filename for reservations (Example: "reservations.csv"): '
  reservations_file = gets.chomp
  
  print 'Please enter the filename for room blocks (Example: "blocks.csv"): '
  blocks_file = gets.chomp
  
  MANAGER.load_files(reservations_file, blocks_file)
  
  puts "Your files were uploaded successfully."
end

def main
  puts "Welcome to Dianna's Hotel Program"
  
  play = true
  
  while play
    print_menu
    
    print "\nPlease choose a menu number: "
    answer = gets.chomp.to_i
    
    until (1..9).include?(answer)
      print "Please enter a valid option: "
      answer = gets.chomp.to_i
    end
    
    case answer
    when 1
      list_rooms
    when 2
      change_price
    when 3
      make_reservation
    when 4
      make_block
    when 5
      confirm_block
    when 6
      daily_reservations
    when 7
      save_data 
    when 8
      load_data
    when 9
      puts "\nGoodbye!"
      play = false
    end
  end
end

main

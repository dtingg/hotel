require "date"
require "csv"

require_relative "lib/booking_manager"
require_relative "lib/errors"
require_relative "lib/reservation"
require_relative "lib/room_block"
require_relative "lib/room"

MANAGER = Hotel::BookingManager.new

def print_menu
  puts "\nMAIN MENU"
  
  menu_options = 
  [
    "List rooms", 
    "Change a room price",
    "Make a reservation", 
    "Make a block reservation", 
    "Confirm a reservation under a block", 
    "List confirmed reservations by day",
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
  
  print "What is the new nightly cost? $"
  new_cost = gets.chomp
  
  while new_cost.include?(".")
    print "Please enter whole dollars only: $"
    new_cost = gets.chomp
  end
  
  new_cost = new_cost.to_i
  
  MANAGER.change_room_cost(room_num: room_num, new_cost: new_cost)
  puts "\nRoom #{room_num} now has a nightly cost of $#{"%.2f" % new_cost}."
end

def make_reservation
  print "Check in date: "
  check_in = gets.chomp
  
  print "Check out date: "
  check_out = gets.chomp
  
  begin
    if Date.parse(check_in) > Date.parse(check_out)
      puts "The check in date cannot be after the check out date."
      return
    end
  rescue ArgumentError
    puts "Those dates aren't valid. Please try again."
    return
  end
  
  begin
    reservation = MANAGER.make_reservation(check_in: check_in, check_out: check_out)
  rescue ArgumentError
    puts "There are no available rooms for those dates."
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
  
  if MANAGER.find_block(name)
    puts "There is already a room block under that name."
    return
  end
  
  print "Check in date: "
  check_in = gets.chomp
  
  print "Check out date: "
  check_out = gets.chomp
  
  begin
    if Date.parse(check_in) > Date.parse(check_out)
      puts "The check in date cannot be after the check out date."
      return
    end
  rescue ArgumentError
    puts "Those dates aren't valid. Please try again."
    return
  end
  
  print "Number of rooms (1 - 5): "
  num_rooms = gets.chomp.to_i
  
  while num_rooms <= 0 || num_rooms > 5
    print "Please enter a valid number of rooms (1 - 5): "
    num_rooms = gets.chomp.to_i
  end
  
  print "Discount percentage (15 for 15%): "
  discount = gets.chomp.to_f
  
  while discount <= 0 || discount > 100
    print "Please enter a valid discount percentage (1 - 100): "
    discount = gets.chomp.to_f
  end
  
  begin
    block = MANAGER.make_block(name: name, check_in: check_in, check_out: check_out, num_rooms: num_rooms, discount: discount)
  rescue ArgumentError
    puts "There are not enough hotel rooms for a block of #{num_rooms} on those dates."
    return
  end
  
  puts "\nHere are your room block details: "
  puts "  Name: #{block.name}"
  puts "  Check in: #{block.check_in}"
  puts "  Check out: #{block.check_out}"
  puts "  Number of rooms: #{block.num_rooms}"
  puts "  Discount: #{block.discount * 100}%"
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
    puts "There are no more available rooms from that block."
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
  print "Enter day (Example: May 1): "
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
  MANAGER.save_rooms("data/rooms.csv")  
  MANAGER.save_reservations("data/reservations.csv")
  MANAGER.save_blocks("data/blocks.csv")
end

def load_data
  MANAGER.load_files("data/rooms.csv", "data/reservations.csv", "data/blocks.csv")
end

def main
  puts "Welcome to Dianna's Hotel Program"
  
  load_data
  
  play = true
  
  while play
    print_menu
    
    print "\nPlease choose a menu number: "
    answer = gets.chomp.to_i
    
    until (1..7).include?(answer)
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
      puts "\nGoodbye!"
      play = false
    end
  end
end

main

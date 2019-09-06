require "simplecov"
SimpleCov.start do
  add_filter "test/"
end

require "minitest"
require "minitest/autorun"
require "minitest/reporters"
require "date"
require "csv"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative "../lib/booking_manager"
require_relative "../lib/reservation"
require_relative "../lib/room_block"
require_relative "../lib/room"

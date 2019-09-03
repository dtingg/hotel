require_relative "test_helper"

describe "DateRange class" do
  describe "Initialize method" do
    it "Creates an instance of DateRange" do
      range = Hotel::DateRange.new("August 1, 2019", "August 5, 2019")
      
      expect(range).must_be_kind_of Hotel::DateRange
    end
    
    it "Keeps track of check-in" do
      range = Hotel::DateRange.new("August 1, 2019", "August 5, 2019")
      
      expect(range).must_respond_to :check_in
      expect(range.check_in).must_equal Date.parse("August 1, 2019")
    end
    
    it "Keeps track of check-out" do
      range = Hotel::DateRange.new("August 1, 2019", "August 5, 2019")
      
      expect(range).must_respond_to :check_out
      expect(range.check_out).must_equal Date.parse("August 5, 2019")
    end
  end
end

require_relative '../lib/string_calculator'
RSpec.describe StringCalculator do
  describe "#add" do
    it "should return 0, when input is an empty string" do
      calculator = StringCalculator.new
      expect(calculator.add("")).to eq 0
    end

    it "should return number itself, when input is a single number string" do
      calculator = StringCalculator.new
      expect(calculator.add("5")).to eq 5
    end

    

  end
end
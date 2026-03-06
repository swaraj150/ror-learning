require_relative '../lib/string_calculator'
RSpec.describe StringCalculator do
  describe "#add" do
    subject(:calculator) { StringCalculator.new }

    it "returns 0 when input is an empty string" do
      expect(calculator.add("")).to eq(0)
    end

    context "when input is a single number" do
      it { expect(calculator.add("5")).to eq(5) }
      it { expect(calculator.add("6")).to eq(6) }
      it { expect(calculator.add("7")).to eq(7) }
    end

    context "when input contains multiple numbers" do
      it { expect(calculator.add("5,6")).to eq(11) }
      it { expect(calculator.add("5,6,7")).to eq(18) }
    end
  end
end
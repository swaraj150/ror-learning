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

    context "handles newline as delimiter" do
      it { expect(calculator.add("5\n6\n7")).to eq(18) }
    end

    context "when input contains a custom delimiter" do
      it "returns sum when custom delimiter is ;" do
        expect(calculator.add("//;\n5;6;7")).to eq(18)
      end

      it "returns sum when custom delimiter is a $" do
        expect(calculator.add("//$\n5$6$7")).to eq(18)
      end
    end

    context "when input contains negative numbers" do
      it { expect { calculator.add("-5,-6,7") }.to raise_error(ArgumentError, "negatives not allowed: -5, -6") }
    end

    context "ignore numbers bigger than 1000" do
      it { expect(calculator.add("5,1001,6,7")).to eq(18) }
    end

    context "when delimiter has multiple characters" do
      it "returns sum when delimiter is ***" do
        expect(calculator.add("//[***]\n5***6***7")).to eq(18)
      end
    end

  end
end
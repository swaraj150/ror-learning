require_relative '../lib/leap_year'

RSpec.describe Year do
describe "#isLeapYear" do

    subject(:year) {Year.new}

    context "when input year is non-leap year" do
      it { expect(year.isLeapYear?(2023)).to be false }
    end
  end
end
require_relative '../lib/leap_year'

RSpec.describe Year do
  describe ".leap?" do

    context "when input year is non-leap year" do
      it { expect(Year.leap?(2023)).to be false }
    end

    context "when input year is a leap year" do
      it { expect(Year.leap?(2024)).to be true }
      it { expect(Year.leap?(2020)).to be true }
      it { expect(Year.leap?(2016)).to be true }
    end
    
    context "when input is a century year" do
      it { expect(Year.leap?(1800)).to be false }
      it { expect(Year.leap?(1700)).to be false }
      it { expect(Year.leap?(1500)).to be false }
      
    end
    
    context "when input is a century year which is leap" do
      it { expect(Year.leap?(1600)).to be true }
      it { expect(Year.leap?(2000)).to be true }
      it { expect(Year.leap?(1200)).to be true }
      
    end



  end
end
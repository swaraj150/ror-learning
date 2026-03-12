require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create(:user) }
   describe 'validations' do

    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:email) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_length_of(:password_digest).is_at_least(8).is_at_most(20) }

  end

  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end


end
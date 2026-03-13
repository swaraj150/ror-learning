
require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { build(:task) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:status) }
    
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(name: 'John', email: "john@abc.com")
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
    end

    it 'is invalid without a email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end
    it 'is invalid with a duplicate email' do
      User.create!(name: "John", email: "john@abc.com")
      user = User.new(name: "John", email: "john@abc.com")
      expect(user).not_to be_valid
    end
  end

  describe 'assocations' do
    it 'has many tasks' do
      user = User.new
      expect(user).to respond_to(:tasks)
    end
  end



end
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.build(:user, name: 'John Doe', email: 'john.doe@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = FactoryBot.build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a short name' do
      user = FactoryBot.build(:user, name: 'A', email: 'john.doe@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too short (minimum is 2 characters)')
    end

    it 'is not valid with a long name' do
      user = FactoryBot.build(:user, name: 'A' * 26, email: 'john.doe@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('is too long (maximum is 25 characters)')
    end

    it 'is not valid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      existing_user = FactoryBot.create(:user, email: 'john.doe@example.com')
      user = FactoryBot.build(:user, email: 'john.doe@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    # Add more validation tests as needed
  end

  describe 'associations' do
    it 'has many products' do
      user = FactoryBot.create(:user)
      expect(user).to respond_to(:products)
    end

    it 'has many reviews' do
      user = FactoryBot.create(:user)
      expect(user).to respond_to(:reviews)
    end

    it 'has many messages' do
      user = FactoryBot.create(:user)
      expect(user).to respond_to(:messages)
    end

    it 'has many solicitudes' do
      user = FactoryBot.create(:user)
      expect(user).to respond_to(:solicituds)
    end

    it 'has one shopping_cart' do
      user = FactoryBot.create(:user)
      expect(user).to respond_to(:shopping_cart)
    end

    # Add more association tests as needed
  end

  describe 'methods' do
    it 'returns true for admin? when role is admin' do
      admin_user = FactoryBot.create(:user, role: 'admin')
      expect(admin_user.admin?).to be true
    end

    it 'returns false for admin? when role is not admin' do
      regular_user = FactoryBot.create(:user, role: 'user')
      expect(regular_user.admin?).to be false
    end

    # Add more method tests as needed
  end
end

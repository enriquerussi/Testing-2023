require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      review = FactoryBot.build(:review, user: user, product: product)
      expect(review).to be_valid
    end

    it 'is not valid without a title' do
      review = FactoryBot.build(:review, user: user, product: product, tittle: nil)
      expect(review).not_to be_valid
      expect(review.errors[:tittle]).to include("can't be blank")
    end

    it 'is not valid with a too long title' do
      review = FactoryBot.build(:review, user: user, product: product, tittle: 'a' * 101)
      expect(review).not_to be_valid
      expect(review.errors[:tittle]).to include('is too long (maximum is 100 characters)')
    end

    it 'is not valid without a description' do
      review = FactoryBot.build(:review, user: user, product: product, description: nil)
      expect(review).not_to be_valid
      expect(review.errors[:description]).to include("can't be blank")
    end

    it 'is not valid with a too long description' do
      review = FactoryBot.build(:review, user: user, product: product, description: 'a' * 501)
      expect(review).not_to be_valid
      expect(review.errors[:description]).to include('is too long (maximum is 500 characters)')
    end

    it 'is not valid without a calification' do
      review = FactoryBot.build(:review, user: user, product: product, calification: nil)
      expect(review).not_to be_valid
      expect(review.errors[:calification]).to include("can't be blank")
    end

    it 'is not valid with a calification greater than 5' do
      review = FactoryBot.build(:review, user: user, product: product, calification: 6)
      expect(review).not_to be_valid
      expect(review.errors[:calification]).to include('must be less than or equal to 5')
    end

    it 'is not valid with a calification less than 1' do
      review = FactoryBot.build(:review, user: user, product: product, calification: 0)
      expect(review).not_to be_valid
      expect(review.errors[:calification]).to include('must be greater than or equal to 1')
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a product' do
      association = described_class.reflect_on_association(:product)
      expect(association.macro).to eq :belongs_to
    end
  end
end

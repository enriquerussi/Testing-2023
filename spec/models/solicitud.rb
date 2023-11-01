require 'rails_helper'

RSpec.describe Solicitud, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      solicitud = FactoryBot.build(:solicitud, user: user, product: product, stock: 5, status: 'pending')
      expect(solicitud).to be_valid
    end

    it 'is not valid without stock' do
      solicitud = FactoryBot.build(:solicitud, user: user, product: product, stock: nil, status: 'pending')
      expect(solicitud).not_to be_valid
      expect(solicitud.errors[:stock]).to include("can't be blank")
    end

    it 'is not valid with non-integer stock' do
      solicitud = FactoryBot.build(:solicitud, user: user, product: product, stock: 2.5, status: 'pending')
      expect(solicitud).not_to be_valid
      expect(solicitud.errors[:stock]).to include("must be an integer")
    end

    it 'is not valid with zero or negative stock' do
      solicitud = FactoryBot.build(:solicitud, user: user, product: product, stock: 0, status: 'pending')
      expect(solicitud).not_to be_valid
      expect(solicitud.errors[:stock]).to include("must be greater than 0")
    end

    it 'is not valid without status' do
      solicitud = FactoryBot.build(:solicitud, user: user, product: product, stock: 5, status: nil)
      expect(solicitud).not_to be_valid
      expect(solicitud.errors[:status]).to include("can't be blank")
    end
  end
end

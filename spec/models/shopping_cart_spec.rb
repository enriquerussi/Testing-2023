require 'rails_helper'

RSpec.describe ShoppingCart, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:product1) { FactoryBot.create(:product, precio: 100) }
  let(:product2) { FactoryBot.create(:product, precio: 200) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      cart = FactoryBot.build(:shopping_cart, user: user, products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(cart).to be_valid
    end
  end

  describe '#precio_total' do
    it 'calculates the total price of products in the shopping cart' do
      cart = FactoryBot.create(:shopping_cart, user: user, products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(cart.precio_total).to eq(400) # (100 * 2) + (200 * 1) = 400
    end

    it 'returns 0 when there are no products in the cart' do
      cart = FactoryBot.create(:shopping_cart, user: user, products: {})
      expect(cart.precio_total).to eq(0)
    end
  end

  describe '#costo_envio' do
    it 'calculates the shipping cost based on products in the cart' do
      cart = FactoryBot.create(:shopping_cart, user: user, products: { product1.id.to_s => 2, product2.id.to_s => 1 })
      expect(cart.costo_envio).to eq(1020)
    end

    it 'returns a fixed shipping cost when there are no products in the cart' do
      cart = FactoryBot.create(:shopping_cart, user: user, products: {})
      expect(cart.costo_envio).to eq(1000)
    end
  end
end

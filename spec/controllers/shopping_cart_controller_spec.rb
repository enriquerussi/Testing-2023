require 'rails_helper'

RSpec.describe ShoppingCartController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product) }
  let(:shopping_cart) { FactoryBot.create(:shopping_cart, user: user) }

  describe 'GET #show' do
    it 'returns http success when user is signed in' do
      sign_in user
      get :show
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root_path when user is not signed in' do
      get :show
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #details' do
    it 'returns http success when user is signed in and cart has products' do
      sign_in user
      shopping_cart.products = { product.id.to_s => 1 }
      shopping_cart.save
      get :details
      expect(response).to have_http_status(:success)
    end

    it 'redirects to /carro when user is not signed in' do
      get :details
      expect(response).to redirect_to('/carro')
    end
  end

  describe 'POST #insertar_producto' do
    it 'adds product to cart and redirects to root_path' do
      sign_in user
      expect {
        post :insertar_producto, params: { product_id: product.id, add: { amount: 1 } }
      }.to change(shopping_cart.products, :count).by(1)
      expect(response).to redirect_to(root_path)
    end
  end

  # ... (other tests for remaining actions)

end

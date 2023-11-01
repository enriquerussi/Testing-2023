require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      product = FactoryBot.create(:product) # Crea un producto de ejemplo utilizando FactoryBot
      get :leer, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #crear" do
    it "redirects to products creation page" do
        get :crear
    end
  end

  describe "POST #insert_deseado" do
    it "redirects to product page after adding product to wishlist" do
      product = FactoryBot.create(:product)
      user = FactoryBot.create(:user)
      sign_in user
      post :insert_deseado, params: { product_id: product.id }
      expect(response).to redirect_to("/products/leer/#{product.id}")
    end
  end

  describe "POST #insertar" do
    it "redirects to products index after creating a product successfully" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      post :insertar, params: { product: FactoryBot.attributes_for(:product) }
      expect(response).to redirect_to('/products/index')
    end

    it "redirects to product creation page after unsuccessful creation attempt" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      post :insertar, params: { product: FactoryBot.attributes_for(:product, nombre: nil) }
      expect(response).to redirect_to('/products/crear')
    end
  end

  describe "GET #actualizar" do
    it "returns http success" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      product = FactoryBot.create(:product)
      get :actualizar, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #actualizar_producto" do
    it "redirects to products index after updating product successfully" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      product = FactoryBot.create(:product)
      patch :actualizar_producto, params: { id: product.id, product: { nombre: 'Nuevo Nombre' } }
      expect(response).to redirect_to('/products/index')
    end

    it "redirects to product update page after unsuccessful update attempt" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      product = FactoryBot.create(:product)
      patch :actualizar_producto, params: { id: product.id, product: { nombre: nil } }
      expect(response).to redirect_to("/products/actualizar/#{product.id}")
    end
  end

  describe "POST #eliminar" do
    it "redirects to products index after deleting product successfully" do
      user = FactoryBot.create(:user, role: 'admin')
      sign_in user
      product = FactoryBot.create(:product)
      post :eliminar, params: { id: product.id }
      expect(response).to redirect_to('/products/index')
    end
  end
end


# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Products", type: :request do
  include Capybara::DSL
  
  before do
    @user = FactoryBot.create(:user)
  end

  describe "GET /new" do
    it "returns http success" do
      sign_in @user # Asegúrate de que esta línea esté dentro del bloque it
      get new_user_password_path
      expect(response).to have_http_status(302)
    end
  end
end

RSpec.describe Product, type: :model do
  before(:each) do
    @user = User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com',
                         role: 'admin')
    @product = Product.new(nombre: 'John1', precio: 4000, stock: 1, user_id: @user.id, categories: 'Cancha')
  end

  it 'is valid with valid attributes' do
    expect(@product).to be_valid
  end
end

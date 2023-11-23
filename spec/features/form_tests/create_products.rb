# spec/features/product_form_spec.rb
require 'rails_helper'

RSpec.feature 'Product Form', type: :feature do
  let(:admin_user) { create(:user, role: 'admin') }

  before do
    User.create(email: 'user@example.com', password: 'password', role: 'admin')
    visit 'products/crear'
  end

  scenario 'Admin creates a new product' do
    # Fill in the form fields
    fill_in 'product[nombre]', with: 'Nuevo Producto'
    select 'Cancha', from: 'product[categories]'
    fill_in 'product[precio]', with: '50'
    fill_in 'product[stock]', with: '10'
    fill_in 'product[horarios]', with: 'Lunes,10:00,18:00;Martes,09:00,17:00'

    # Attach an image (you may need to adjust this based on your setup)
    attach_file('product[image]', Rails.root + 'app/assets/images/base.jpg')

    # Submit the form
    click_button 'Guardar'

    # Assert that the product was created successfully
    expect(page).to have_content('Producto creado exitosamente')
    expect(Product.last.nombre).to eq('Nuevo Producto')
    expect(Product.last.categories).to eq('Cancha')
    expect(Product.last.precio).to eq(50)
    expect(Product.last.stock).to eq(10)
    expect(Product.last.horarios).to eq('Lunes,10:00,18:00;Martes,09:00,17:00')
  end
end

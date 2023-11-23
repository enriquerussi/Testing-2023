# spec/features/product_form_spec.rb
require 'rails_helper'


RSpec.feature 'Product Form', type: :feature do
    let!(:admin_user) do
        User.create!(name: 'John1', password: 'Nonono123!', email: 'asdf@gmail.com', role: 'admin')
    end

    before do
        login_as(admin_user, scope: :user)
    end

  scenario 'Admin creates a new product' do
    visit 'products/crear'
    fill_in 'product[nombre]', with: 'Nuevo Producto'
    select 'Cancha', from: 'product[categories]'
    fill_in 'product[precio]', with: '50'
    fill_in 'product[stock]', with: '10'
    fill_in 'product[horarios]', with: 'Lunes,10:00,18:00;Martes,09:00,17:00'

    attach_file('product[image]', Rails.root + 'app/assets/images/base.jpg')

    click_button 'Guardar'

    expect(Product.last.nombre).to eq('Nuevo Producto')
    expect(Product.last.categories).to eq('Cancha')
    expect(Product.last.precio).to eq("50")
    expect(Product.last.stock).to eq("10")
    expect(Product.last.horarios).to eq('Lunes,10:00,18:00;Martes,09:00,17:00')
  end

  scenario 'Admin creates a new product without name' do
    visit 'products/crear'
    select 'Cancha', from: 'product[categories]'
    fill_in 'product[precio]', with: '50'
    fill_in 'product[stock]', with: '10'
    fill_in 'product[horarios]', with: 'Lunes,10:00,18:00;Martes,09:00,17:00'

    attach_file('product[image]', Rails.root + 'app/assets/images/base.jpg')

    click_button 'Guardar'

    expect(Product.last).to be_nil
  end

  scenario 'Admin creates a new product without stock' do
    visit 'products/crear'
    fill_in 'product[nombre]', with: 'Nuevo Producto'
    select 'Cancha', from: 'product[categories]'
    fill_in 'product[precio]', with: '50'
    fill_in 'product[horarios]', with: 'Lunes,10:00,18:00;Martes,09:00,17:00'

    attach_file('product[image]', Rails.root + 'app/assets/images/base.jpg')

    click_button 'Guardar'

    expect(Product.last).to be_nil
  end

  scenario 'Admin creates a new product without price' do
    visit 'products/crear'
    fill_in 'product[nombre]', with: 'Nuevo Producto'
    select 'Cancha', from: 'product[categories]'
    fill_in 'product[stock]', with: '50'
    fill_in 'product[horarios]', with: 'Lunes,10:00,18:00;Martes,09:00,17:00'

    attach_file('product[image]', Rails.root + 'app/assets/images/base.jpg')

    click_button 'Guardar'

    expect(Product.last).to be_nil
  end
end

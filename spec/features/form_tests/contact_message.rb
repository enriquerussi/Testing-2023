# spec/features/contact_form_spec.rb
require 'rails_helper'

RSpec.feature 'Contact Form', type: :feature do
  scenario 'User submits contact form' do
    visit '/contacto'
    fill_in 'contact[name]', with: 'John Doe'
    fill_in 'contact[mail]', with: 'john.doe@example.com'
    fill_in 'contact[phone]', with: '+56912345678'
    fill_in 'contact[title]', with: 'Consulta'
    fill_in 'contact[body]', with: 'Hola, tengo una pregunta.'
    click_button 'Enviar'
    expect(page).to have_content('Mensaje de contacto enviado correctamente')
  end

  scenario 'User submits contact form without name' do
    visit '/contacto'
    fill_in 'contact[mail]', with: 'john.doe@example.com'
    fill_in 'contact[phone]', with: '+56912345678'
    fill_in 'contact[title]', with: 'Consulta'
    fill_in 'contact[body]', with: 'Hola, tengo una pregunta.'
    before_state = page.html
    click_button 'Enviar'
    sleep 2
    after_state = page.html
    expect(after_state).to eq(before_state)
  end

  scenario 'User submits contact form without mail' do
    visit '/contacto'
    fill_in 'contact[name]', with: 'John Doe'
    fill_in 'contact[phone]', with: '+56912345678'
    fill_in 'contact[title]', with: 'Consulta'
    fill_in 'contact[body]', with: 'Hola, tengo una pregunta.'
    before_state = page.html
    click_button 'Enviar'
    sleep 2
    after_state = page.html
    expect(after_state).to eq(before_state)
  end

end

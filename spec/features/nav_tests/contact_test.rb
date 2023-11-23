require 'rails_helper'

RSpec.feature 'Navegación', type: :feature do
  scenario 'Usuario visita la página de contacto' do
    visit '/'
    expect(page).to have_content('Ejercita. Juega. Disfruta.')
    expect(page).to have_link('Contacto', href: '/contacto', visible: :all)

    # Click on the "Contacto" link
    click_button 'Contacto'
    expect(page).to have_content('Contacto')
  end
end

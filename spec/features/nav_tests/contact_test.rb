require 'rails_helper'

RSpec.feature 'Navegación', type: :feature do
  scenario 'Usuario visita la página de contacto' do
    visit pages_index_path
    sleep 5
    expect(page).to have_content('Ejercita. Juega. Disfruta.')
    expect(page).to have_link('Contacto', href: '/contacto', visible: :all)

    # Click on the "Contacto" link
    find('a.button.is-dark.is-large', text: 'Contacto').click
    expect(page).to have_content('Contacto')
  end
end
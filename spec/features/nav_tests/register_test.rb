# spec/features/navegacion_spec.rb

require 'rails_helper'

RSpec.feature 'Navegación', type: :feature do
  scenario 'Usuario visita la página de registrar' do
    # Visitar la página de inicio
    visit pages_index_path
    expect(page).to have_content('Ejercita. Juega. Disfruta.')

    expect(page).to have_link('Regístrate', href: '/register', visible: :all)

    # Hacer clic en un producto para ver detalles
    sleep(2)
    find('a.button.is-rounded', text: 'Regístrate').click
    expect(page).to have_content('Registro')
  end
end

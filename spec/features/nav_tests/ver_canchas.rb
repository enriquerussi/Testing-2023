# spec/features/navegacion_spec.rb

require 'rails_helper'

RSpec.feature 'Navegación', type: :feature do
  scenario 'Usuario visita la página de inicair sesión' do
    # Visitar la página de inicio
    visit pages_index_path
    expect(page).to have_content('Ejercita. Juega. Disfruta.')

    # Hacer clic en un producto para ver detalles
    find('a.button.is-dark', text: 'Ver canchas y productos').click
    expect(page).to have_content('Canchas y productos')
  end
end
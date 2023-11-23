# spec/features/navegacion_spec.rb

require 'rails_helper'

RSpec.feature 'Navegación', type: :feature do
  scenario 'Usuario visita la página de inicair sesión' do
    # Visitar la página de inicio
    visit root
    expect(page).to have_content('Ejercita. Juega. Disfruta.')

    # Hacer clic en un producto para ver detalles
    click_link 'Iniciar Sesión', match: :first
    expect(page).to have_content('Iniciar Sesión')
    
  end
end
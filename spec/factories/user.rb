FactoryBot.define do
    factory :user do
      name { Faker::Name.name } # Utiliza Faker para generar un nombre aleatorio
      email { Faker::Internet.email } # Utiliza Faker para generar un correo electrónico aleatorio
      password { 'password123' } # Contraseña predeterminada para propósitos de prueba, ajusta según sea necesario
      role { 'user' } # Rol predeterminado para propósitos de prueba, ajusta según sea necesario
  
      # Asociación con la imagen (opcional, si también quieres crear un avatar para el usuario)
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'example.jpg'), 'image/jpeg') } # Asegúrate de tener un archivo de imagen llamado example.jpg en el directorio spec/support
  
      # Relación con el modelo Product (opcional, si también quieres crear productos asociados al usuario)
      transient do
        products_count { 0 } # Puedes ajustar el número de productos que quieres crear por usuario
      end
  
      after(:create) do |user, evaluator|
        create_list(:product, evaluator.products_count, user: user)
      end
    end
  end
  
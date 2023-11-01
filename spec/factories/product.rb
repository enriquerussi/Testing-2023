FactoryBot.define do
  factory :product do
    categories { ['Cancha', 'Accesorio tecnologico', 'Accesorio deportivo', 'Accesorio de vestir', 'Accesorio de entrenamiento', 'Suplementos', 'Equipamiento'].sample }
    nombre { Faker::Lorem.word } # Utiliza Faker para generar un nombre aleatorio
    stock { Faker::Number.between(from: 1, to: 100) } # Genera un número aleatorio entre 1 y 100 para el stock
    precio { Faker::Number.decimal(l_digits: 2) } # Genera un número decimal aleatorio con 2 dígitos
    user
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'example.jpg'), 'image/jpeg') } # Asegúrate de tener un archivo de imagen llamado example.jpg en el directorio spec/support

    # Relación con el modelo Review (opcional, si también quieres crear reviews al crear un producto)
    transient do
      reviews_count { 0 } # Puedes ajustar el número de reviews que quieres crear por producto
    end

    after(:create) do |product, evaluator|
      create_list(:review, evaluator.reviews_count, product: product)
    end
  end
end

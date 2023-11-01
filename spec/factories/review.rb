FactoryBot.define do
    factory :review do
      name { Faker::Lorem.word } # Utiliza Faker para generar un nombre aleatorio
      # Otros atributos de la fábrica, si los hay
    end
  end
  
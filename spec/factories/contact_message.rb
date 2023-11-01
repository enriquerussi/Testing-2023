FactoryBot.define do
    factory :contact_message do
      name { Faker::Name.name }
      mail { Faker::Internet.email }
      phone { '+56912345678' }
      title { Faker::Lorem.sentence }
      body { Faker::Lorem.paragraph }
  
      # Si necesitas crear un mensaje de contacto con atributos específicos, puedes hacerlo así:
      # trait :with_specific_attributes do
      #   name { 'Nombre específico' }
      #   mail { 'correo@example.com' }
      #   phone { '123-456-7890' }
      #   title { 'Título específico' }
      #   body { 'Cuerpo específico del mensaje de contacto' }
      # end
    end
  end
  
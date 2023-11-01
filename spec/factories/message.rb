FactoryBot.define do
    factory :message do
      body { Faker::Lorem.sentence } # Utiliza Faker para generar un cuerpo de mensaje aleatorio
      association :user
      association :product
      ancestry { '1' }
  
      # Relación con ancestros (opcional, si también quieres crear mensajes con ancestros)
      transient do
        parent_message { nil }
      end
  
      after(:build) do |message, evaluator|
        message.parent = evaluator.parent_message if evaluator.parent_message
      end
    end
  end
  
FactoryBot.define do
    factory :review do
      tittle { 'New Title' } # Utiliza Faker para generar un título aleatorio con 3 palabras
      description { Faker::Lorem.paragraph(sentence_count: 2) } # Utiliza Faker para generar una descripción aleatoria con 2 oraciones
      calification { Faker::Number.between(from: 1, to: 5) } # Genera una calificación aleatoria entre 1 y 5
  
      # Asociaciones con los modelos Product y User
      association :product
      association :user
  
      # Puedes agregar más atributos según tus necesidades o ajustar los existentes
  
      # Valida que la asociación con el producto esté presente (opcional, dependiendo de tu caso)
      # validates :product, presence: true
  
      # Valida que la asociación con el usuario esté presente (opcional, dependiendo de tu caso)
      # validates :user, presence: true
    end
  end
  
  
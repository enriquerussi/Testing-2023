FactoryBot.define do
    factory :solicitud do
      association :user
      association :product
      stock { 5 } 
      status { 'Pendiente' } 
    end
  end
  
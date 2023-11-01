FactoryBot.define do
    factory :shopping_cart do
      user
      products { { FactoryBot.create(:product) => Faker::Number.between(from: 1, to: 10) } }
    end
  end
  
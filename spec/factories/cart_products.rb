FactoryBot.define do
  factory :cart_product do
    association :cart
    association :product

    quantity { FFaker::Random.rand(1..10) }
  end
end

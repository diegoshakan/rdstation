FactoryBot.define do
  factory :cart_product do
    association :cart
    association :product
  end
end

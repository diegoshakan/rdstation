FactoryBot.define do
  factory :product do
    name { FFaker::Product.product_name }
    price { FFaker.numerify('##.##') }
  end
end

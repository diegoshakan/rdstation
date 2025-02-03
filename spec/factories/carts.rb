FactoryBot.define do
  factory :cart do
    total_price { FFaker.numerify('##.##') }
  end
end

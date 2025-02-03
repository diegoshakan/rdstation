FactoryBot.define do
  factory :cart do
    total_price { FFaker.numerify('##.##') }
    last_interaction_at { Time.current }

    trait :abandoned do
      abandoned_at { Time.current }
    end

    trait :cart_abandoned do
      abandoned_at { 8.days.ago }
    end
  end
end

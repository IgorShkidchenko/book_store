FactoryBot.define do
  factory :order_item do
    quantity { Faker::Number.between(3, 5) }

    book
    order

    trait :with_min_quantity do
      quantity { OrderItems::QuantityUpdaterService::MIN_QUANTITY }
    end
  end
end

FactoryBot.define do
  factory :order_item do
    quantity { Faker::Number.between(1, 5) }
    total_price { Faker::Number.decimal(2) }

    book
  end
end

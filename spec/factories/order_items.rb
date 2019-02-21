FactoryBot.define do
  factory :order_item do
    quantity { Faker::Number.between(3, 5) }

    book
    order
  end
end

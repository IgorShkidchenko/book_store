FactoryBot.define do
  factory :order do
    subtotal_price { Faker::Number.decimal(3) }
    total_price { Faker::Number.decimal(3) }

    order_status

    trait :with_order_items do
      after(:create) do |order|
        create(:order_item, order: order)
      end
    end

    trait :with_coupon do
      after(:create) do |order|
        create(:coupon, order: order)
      end
    end
  end
end

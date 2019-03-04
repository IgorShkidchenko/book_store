FactoryBot.define do
  factory :order do
    number { SecureRandom.hex(4) }

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

    trait :with_user do
      user
    end
  end
end

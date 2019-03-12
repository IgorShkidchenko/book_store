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

    trait :completed_with_user do
      after(:create) do |order|
        order.addresses.create!(attributes_for(:address, :billing))
        order.addresses.create!(attributes_for(:address, :shipping))
        create(:credit_card, order: order)
        create(:order_item, order: order)
      end
      user
      delivery_method
      aasm_state { Order.aasm_states[:delivered] }
    end
  end
end

FactoryBot.define do
  factory :order do
    number { Checkout::CompleteService::FIRST_ORDER_NUMBER_SYMBOL + Time.now.strftime(Checkout::CompleteService::CURRENT_DATE) }

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

    factory :order_in_checkout_form_steps, parent: :order do
      after(:create) do |order|
        create(:order_item, order: order)
      end

      user

      trait :delivery_step do
        aasm_state { Order.aasm_states[:fill_delivery] }
      end

      trait :payment_step do
        after(:create) do |order|
          order.addresses.create!(attributes_for(:address, :billing))
          order.addresses.create!(attributes_for(:address, :shipping))
        end

        delivery_method

        aasm_state { Order.aasm_states[:fill_payment] }
      end
    end

    factory :order_in_checkout_final_steps, parent: :order do
      after(:create) do |order|
        order.addresses.create!(attributes_for(:address, :billing))
        order.addresses.create!(attributes_for(:address, :shipping))
        create(:credit_card, order: order)
        create(:order_item, order: order)
      end

      user
      delivery_method

      trait :confirm_step do
        aasm_state { Order.aasm_states[:editing] }
      end

      trait :in_progress do
        aasm_state { Order.aasm_states[:in_progress] }
      end

      trait :in_queue do
        aasm_state { Order.aasm_states[:in_queue] }
      end

      trait :in_delivery do
        aasm_state { Order.aasm_states[:in_delivery] }
      end

      trait :delivered do
        aasm_state { Order.aasm_states[:delivered] }
      end
    end
  end
end

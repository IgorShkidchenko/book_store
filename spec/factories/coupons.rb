FactoryBot.define do
  factory :coupon do
    key { 'encrypted_key' }
    discount { 10 }

    trait :used do
      used { true }
    end
  end
end

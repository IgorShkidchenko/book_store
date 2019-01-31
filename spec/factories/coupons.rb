FactoryBot.define do
  factory :coupon do
    key { 'encrypted_key' }
    discount { 10 }
  end
end

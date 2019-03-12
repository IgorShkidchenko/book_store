FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now }

    trait :with_addresses do
      after(:create) do |user|
        user.addresses.create!(attributes_for(:address, :billing))
        user.addresses.create!(attributes_for(:address, :shipping))
      end
    end
  end
end

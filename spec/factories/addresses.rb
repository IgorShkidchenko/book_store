FactoryBot.define do
  factory :address do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    city { Faker::Games::Witcher.location }
    street { Faker::Address.street_name }
    phone { Faker::PhoneNumber.phone_number_with_country_code.first(10) }
    zip { Faker::Number.number(5) }
    country { Faker::Address.country_code }

    trait :billing do
      kind { Address.kinds[:billing] }
    end

    trait :shipping do
      kind { Address.kinds[:shipping] }
    end
  end
end

FactoryBot.define do
  factory :credit_card do
    name { Faker::Currency.name }
    number { Faker::Number.number(16) }
    expire_date { "12/#{Time.now.year - ExpireDateInFutureValidator::CENTURY}" }
    cvv { Faker::Number.number(3) }

    order
  end
end

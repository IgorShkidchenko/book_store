FactoryBot.define do
  factory :review do
    title { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
    rating { Faker::Number.between(1, 5) }

    book
    user
  end
end

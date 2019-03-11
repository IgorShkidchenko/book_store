FactoryBot.define do
  factory :delivery_method do
    name { Faker::Lorem.word }
    min_days { rand(1..5) }
    max_days { rand(1..5) }
    cost { rand(10..30) }
  end
end

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    price { Faker::Number.decimal(2) }
    description { Faker::Lorem.paragraph_by_chars(Faker::Number.between(300, 350), false) }
    published_year { Faker::Number.between(2000, Time.now.year) }
    height { Faker::Number.decimal(2) }
    width { Faker::Number.decimal(2) }
    depth { Faker::Number.decimal(2) }
    materials { Faker::Science.element }
    slug { Faker::Book.title }
    cover { nil }

    trait :with_author do
      after(:create) do |book|
        create(:author, books: [book])
      end
    end
  end
end

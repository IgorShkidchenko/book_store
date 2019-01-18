FactoryBot.define do
  factory :category do
    name { Faker::Book.genre }

    trait :with_book do
      after(:create) do |category|
        create(:book, :with_author, category: category)
      end
    end
  end
end

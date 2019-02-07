FactoryBot.define do
  factory :category do
    name { Faker::Book.genre }

    trait :with_book do
      after(:create) do |category|
        create(:book, :with_author_and_cover, category: category)
      end
    end

    trait :with_books do
      after(:create) do |category|
        create_list(:book, 13, category: category)
      end
    end
  end
end

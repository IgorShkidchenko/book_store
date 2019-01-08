FactoryBot.define do
  factory :category do
    name { Faker::Book.genre }

    factory :category_with_book do
      after(:create) do |category|
        create(:book, category: category)
      end
    end
  end
end

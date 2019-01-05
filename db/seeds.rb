require 'faker'

30.times { Author.create(name: Faker::Book.author) }

Array.new(4) { Category.create(name: Faker::Book.genre) }.each do |category|
  Faker::Number.between(20, 50).times do
    category.books.create(title: Faker::Book.title,
                          price: Faker::Number.decimal(2),
                          description: Faker::Lorem.paragraph_by_chars(Faker::Number.between(300, 350), false),
                          published_year: Faker::Number.between(2000, Time.now.year),
                          height: Faker::Number.decimal(2),
                          width: Faker::Number.decimal(2),
                          depth: Faker::Number.decimal(2),
                          materials: Faker::Science.element).authors << Author.all.sample(Faker::Number.between(1, 3))
  end
end

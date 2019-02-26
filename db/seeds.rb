require 'faker'

def random_image
  "public/img/#{rand(1..15)}.jpg"
end

30.times { Author.create(name: Faker::Book.author) }

User.create(email: 'user@example.com', password: 'password')
AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

Array.new(4) { Category.create(name: Faker::Book.genre) }.each do |category|
  Faker::Number.between(20, 50).times do
    book = category.books.create(title: Faker::Book.title,
                                 price: Faker::Number.decimal(2),
                                 description: Faker::Lorem.paragraph_by_chars(Faker::Number.between(300, 350), false),
                                 published_year: Faker::Number.between(2000, Time.now.year),
                                 height: Faker::Number.decimal(2),
                                 width: Faker::Number.decimal(2),
                                 depth: Faker::Number.decimal(2),
                                 materials: Faker::Science.element)
    book.authors << Author.all.sample(Faker::Number.between(1, 2))
  end

  category.books.first(5).each do |book|
    cover = book.covers.create
    File.open(random_image) do |f|
      cover.image = f
    end
    cover.save!
    book.reviews.create(title: Faker::Lorem.word, body: Faker::Lorem.sentence, status: Review::STATUSES[:approved],
                        rating: Faker::Number.between(1, 5), user_id: User.first.id)

    book.reviews.create(title: Faker::Lorem.word, body: Faker::Lorem.sentence,
                        rating: Faker::Number.between(1, 5), user_id: User.first.id)
  end
end

10.times { Coupon.create(key: SecureRandom.base64(12)) }

DeliveryMethod.create(name: 'Express Delivery', cost: 30, min_days: 1, max_days: 2)
DeliveryMethod.create(name: 'Standart Delivery', cost: 10, min_days: 3, max_days: 7)
DeliveryMethod.create(name: 'Pick up from our shop', cost: 0, min_days: 0, max_days: 0)

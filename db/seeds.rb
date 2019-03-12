require 'faker'

30.times { Author.create!(name: Faker::Book.author) }
all_authors = Author.all

password = 'password'.freeze
user = User.new(email: 'user@example.com', password: password)
user.skip_confirmation!
user.save!
AdminUser.create!(email: 'admin@example.com', password: password, password_confirmation: password)

Array.new(4) { Category.create!(name: Faker::Book.genre) }.each do |category|
  rand(20..50).times do
    book = category.books.create!(title: Faker::Book.title,
                                  price: Faker::Number.decimal(2),
                                  description: Faker::Lorem.paragraph_by_chars(rand(300..350), false),
                                  published_year: rand(2000..Time.now.year),
                                  height: Faker::Number.decimal(2),
                                  width: Faker::Number.decimal(2),
                                  depth: Faker::Number.decimal(2),
                                  materials: Faker::Science.element)
    book.authors << all_authors.sample(rand(1..2))
  end

  category.books.first(5).each do |book|
    book.reviews.create!(title: Faker::Lorem.word, body: Faker::Lorem.sentence, status: 1,
                         rating: rand(1..5), user_id: user.id)

    book.reviews.create!(title: Faker::Lorem.word, body: Faker::Lorem.sentence,
                         rating: rand(1..5), user_id: user.id)
  end
end

def coupon_secret_number
  Time.now.strftime(Coupons::KeyGeneratorService::MILISEC_SEC_MINUTE) + SecureRandom.hex(5)
end

10.times { Coupon.create!(key: coupon_secret_number) }

DeliveryMethod.create!(name: 'Express Delivery', cost: 30, min_days: 1, max_days: 2)
DeliveryMethod.create!(name: 'Standart Delivery', cost: 10, min_days: 3, max_days: 7)
DeliveryMethod.create!(name: 'Pick up from our shop', cost: 0, min_days: 0, max_days: 0)

def uniq_code_number
  Checkout::CompleteService::FIRST_ORDER_NUMBER_SYMBOL + Time.now.strftime(Checkout::CompleteService::CURRENT_DATE)
end

8.times do |index|
  Order.create!(user_id: user.id,
                aasm_state: index,
                number: uniq_code_number,
                delivery_method_id: rand(1..3))

  2.times do |index_id|
    Order.last.addresses.create!(first_name: Faker::Name.first_name,
                                 last_name: Faker::Name.last_name,
                                 city: Faker::Games::Witcher.location,
                                 street: Faker::Address.street_name,
                                 phone: Faker::PhoneNumber.phone_number_with_country_code.first(10),
                                 zip: Faker::Address.zip,
                                 country: Faker::Address.country,
                                 kind: index_id)
  end

  CreditCard.create!(number: Faker::Number.number(16),
                     name: Faker::Currency.name,
                     cvv: Faker::Number.number(3),
                     expire_date: "12/#{Time.now.year - ExpireDateInFutureValidator::CENTURY}",
                     order_id: index + 1)
end

Order.count.times do |index|
  rand(1..3).times { OrderItem.create!(order_id: index + 1, book_id: rand(1..50), quantity: rand(1..2)) }
end

completed_order = Order.find_by(aasm_state: Order.aasm_states[:delivered])
4.times do |index|
  OrderItem.create!(order: completed_order, book: Book.find_by(category_id: index + 1), quantity: 1)
end

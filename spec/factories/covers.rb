FactoryBot.define do
  factory :cover do
    image { Rack::Test::UploadedFile.new(File.open(File.join("#{::Rails.root}/spec/fixtures/covers/book_cover.jpg"))) }
    book
  end
end

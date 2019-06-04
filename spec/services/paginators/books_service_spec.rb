require 'rails_helper'

RSpec.describe Paginators::BooksService do
  subject(:paginators_books_service) { described_class }

  let(:category) { build(:category, :with_books) }
  let(:fake_params) { 'fake params' }
  let(:fake_books) { [build(:book)] }

  it 'with category' do
    expect(Books::FilterQuery).to receive(:call).with(books: category.books, params: fake_params)
    paginators_books_service.call(category: category, params: fake_params)
  end

  it 'with out category' do
    allow(Book).to receive(:all).and_return(fake_books)
    expect(Books::FilterQuery).to receive(:call).with(books: fake_books, params: fake_params)
    paginators_books_service.call(category: nil, params: fake_params)
  end
end

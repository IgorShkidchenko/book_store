require 'rails_helper'

RSpec.describe BookDecorator do
  let(:book) { FactoryBot.build_stubbed(:book, :with_author).decorate }

  context 'when description' do
    let(:valid_short_description_size) { 150 }
    let(:valid_medium_description_size) { 250 }
    let(:valid_the_rest_of_description_size) { book.description.size - valid_medium_description_size }

    it { expect(book.short_description.size).to eq valid_short_description_size }
    it { expect(book.medium_description.size).to eq valid_medium_description_size }
    it { expect(book.the_rest_of_description.size).to eq valid_the_rest_of_description_size }
  end

  context 'when authors_as_string' do
    let(:book_author) { book.authors.first.to_s }

    it { expect(book.authors_as_string.class).to eq String }
    it { expect(book.authors_as_string).to include book_author }
  end
end

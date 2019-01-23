require 'rails_helper'

RSpec.describe AuthorDecorator do
  let(:author) { FactoryBot.build_stubbed(:author).decorate }

  context 'when assosiated_books_quantity' do
    let(:count) { 5 }
    let(:books) { FactoryBot.build_stubbed_list(:book, count) }

    before { allow(author).to receive(:books).and_return(books) }

    it { expect(author.assosiated_books_quantity).to eq count }
  end
end

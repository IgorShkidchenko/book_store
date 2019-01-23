require 'rails_helper'

RSpec.describe CategoryDecorator do
  let(:category) { FactoryBot.build_stubbed(:category).decorate }

  context 'when assosiated_books_quantity' do
    let(:count) { 5 }
    let(:books) { FactoryBot.build_stubbed_list(:book, count) }

    before { allow(category).to receive(:books).and_return(books) }

    it { expect(category.assosiated_books_quantity).to eq count }
  end
end

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'when visit show page' do
    let(:book) { FactoryBot.create(:book) }

    before do
      get :show, params: { id: book.id }
      allow(Book).to receive(:find).and_return(book)
    end

    it { is_expected.to render_template('show') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/books/1').to(action: :show, id: 1) }
  end
end

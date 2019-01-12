require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'when visit show page' do
    let(:library) { FactoryBot.create(:category, :with_book) }

    before { get :show, params: { id: library.books.first.id } }

    it { is_expected.to render_template('show') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/books/1').to(action: :show, id: 1) }
  end
end

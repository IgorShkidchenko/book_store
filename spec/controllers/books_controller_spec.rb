require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'when visit show page' do
    let(:book) { FactoryBot.create(:book) }

    before do
      allow(Book).to receive(:find).and_return(book)
      get :show, params: { id: book.id }
    end

    it { expect(assigns(:book)).to eq book }
    it { is_expected.to render_template 'show' }
    it { is_expected.to respond_with 200 }
    it { is_expected.to route(:get, '/books/2').to(action: :show, id: 2) }
  end

  describe 'when visit index page' do
    let(:category) { FactoryBot.create(:category, :with_book) }
    let(:book) { category.books.last.decorate }

    before do
      get :index, params: { category_id: category.id }
      allow(Category).to receive(:find).and_return(category)
      allow(Book).to receive(:all).and_return(book)
    end

    it { expect(assigns(:category)).to eq category }
    it { expect(assigns(:chosen_books)).to include book }
    it { is_expected.to render_template 'index' }
    it { is_expected.to respond_with 200 }
    it { is_expected.to route(:get, '/categories/1/books').to(action: :index, category_id: 1) }
  end
end

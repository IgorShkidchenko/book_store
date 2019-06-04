require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:category) { create(:category, :with_book) }
  let(:book) { category.books.last }

  describe 'when #show' do
    before do
      allow(Book).to receive(:find).and_return(book)
      get :show, params: { id: book.id }
    end

    it { is_expected.to render_template 'show' }
    it { is_expected.to respond_with 200 }
    it { expect(assigns(:book)).to eq book }
  end

  describe 'when #index' do
    before do
      allow(Category).to receive(:find).and_return(category)
      allow(CatalogPresenter).to receive(:new)
      allow(subject).to receive(:present)
      get :index, params: { category_id: category.id }
    end

    it { is_expected.to render_template 'index' }
    it { is_expected.to respond_with 200 }
    it { expect(assigns(:category)).to eq category }
    it { expect(assigns(:chosen_books)).to include book }
  end

  describe 'when routes' do
    it { is_expected.to route(:get, "/books/#{book.id}").to(action: :show, id: book.id) }
    it { is_expected.to route(:get, "/categories/#{category.id}/books").to(action: :index, category_id: category.id) }
  end
end

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'when visit index page' do
    let(:category) { FactoryBot.create(:category, :with_book) }
    let(:book) { category.books.last.decorate }

    before do
      get :index, params: { category_id: category.id }
      allow(Category).to receive(:find).and_return(category)
      allow(Book).to receive(:all).and_return(book)
    end

    it { expect(assigns(:category)).to eq category }
    it { expect(assigns(:books)).to include book }
    it { expect(assigns(:chosen_books)).to include book }
    it { is_expected.to render_template('index') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/categories').to(action: :index) }
  end
end

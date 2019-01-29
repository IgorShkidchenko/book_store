require 'rails_helper'

RSpec.describe Admin::BooksController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let!(:book) { FactoryBot.create(:book, :with_author_and_cover).decorate }

    let(:valid_attributes) { (FactoryBot.attributes_for :book).merge(category_id: book.category_id) }
    let(:invalid_attributes) { { title: nil, category_id: book.category_id } }

    render_views
    login_admin

    describe 'when index' do
      before { get :index }

      it { expect(subject.current_admin_user).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:books)).to include book }
      it { expect(page).to have_content book.title }
      it { expect(page).to have_content book.authors_as_string }
      it { expect(page).to have_content I18n.t('book.short_description', description: book.short_description) }
      it { expect(page).to have_content I18n.t('price', price: book.price) }
      it { expect(page).to have_content I18n.t('admin.actions.view') }
      it { expect(page).to have_content I18n.t('admin.actions.edit') }
      it { expect(page).to have_content I18n.t('admin.actions.delete') }
    end

    describe 'when new' do
      before { get :new }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:book)).to be_a_new Book }
      it { expect(page).to have_field 'book_title' }
      it { expect(page).to have_field 'book_description' }
      it { expect(page).to have_field 'book_price' }
      it { expect(page).to have_field 'book_category_id' }
      it { expect(page).to have_field 'book_author_ids' }
      it { expect(page).to have_field 'book_materials' }
      it { expect(page).to have_field 'book_height' }
      it { expect(page).to have_field 'book_width' }
      it { expect(page).to have_field 'book_depth' }
      it { expect(page).to have_content I18n.t('admin.book_form.cover_title') }
      it { expect(page).to have_content I18n.t('admin.actions.create_with_faker') }
    end

    describe 'when create with valid params' do
      before do |example|
        post :create, params: { book: valid_attributes } unless example.metadata[:skip_before]
      end

      it 'when Book incrases', skip_before: true do
        expect do
          post :create, params: { book: valid_attributes }
        end.to change(Book, :count).by(1)
      end

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:book)).to be_a Book }
      it { expect(assigns(:book)).to be_persisted }
      it { expect(response).to redirect_to admin_book_path(Book.last) }
      it { expect(Book.last.title).to eq valid_attributes[:title] }
    end

    describe 'when create with invalid params' do
      before do |example|
        post :create, params: { book: invalid_attributes } unless example.metadata[:skip_before]
      end

      it 'when Book does not incrase', skip_before: true do
        expect do
          post :create, params: { book: invalid_attributes }
        end.not_to change(Book, :count)
      end

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:book)).to be_a_new(Book) }
    end

    describe 'when edit' do
      before { get :edit, params: { id: book.slug } }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:book)).to eq(book) }
      it { expect(page).to have_field 'book_title', with: book.title }
      it { expect(page).to have_field 'book_description', with: book.description }
      it { expect(page).to have_field 'book_price', with: book.price }
      it { expect(page).to have_field 'book_category_id', with: book.category_id }
      it { expect(page).to have_field 'book_materials', with: book.materials }
      it { expect(page).to have_field 'book_height', with: book.height }
      it { expect(page).to have_field 'book_width', with: book.width }
      it { expect(page).to have_field 'book_depth', with: book.depth }
    end

    describe 'when update with valid params' do
      before { put :update, params: { id: book.slug, book: valid_attributes } }

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:book)).to eq book }
      it { expect(response).to redirect_to admin_book_path(book) }

      it do
        book.reload
        expect(book.title).to eq valid_attributes[:title]
      end

      it do
        book.reload
        expect(book.covers.last).not_to eq nil
      end
    end

    describe 'when update with invalid params' do
      before do |example|
        put :update, params: { id: book.slug, book: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it 'when book does not update', skip_before: true do
        expect do
          put :update, params: { id: book.slug, book: invalid_attributes }
        end.not_to(change { book.reload.title })
      end
    end

    describe 'when show' do
      before { get :show, params: { id: book.slug } }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:book)).to eq book }
      it { expect(page).to have_content book.title }
      it { expect(page).to have_content book.description }
      it { expect(page).to have_content book.price }
      it { expect(page).to have_content book.category.name }
      it { expect(page).to have_content book.materials }
      it { expect(page).to have_content book.height }
      it { expect(page).to have_content book.width }
      it { expect(page).to have_content book.depth }
      it { expect(page).to have_content I18n.t('admin.actions.show_on_site') }
      it { expect(page).to have_content I18n.t('admin.actions.edit') }
      it { expect(page).to have_content I18n.t('admin.actions.delete') }
    end

    describe 'when destroy' do
      it do
        expect do
          delete :destroy, params: { id: book.slug }
        end.to change(Book, :count).by(-1)
      end

      it 'redirects to the field' do
        delete :destroy, params: { id: book.slug }
        expect(response).to redirect_to(admin_books_path)
      end
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/books').to(action: :index) }
    it { is_expected.to route(:get, '/admin/books/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/admin/books/new').to(action: :new) }
    it { is_expected.to route(:post, '/admin/books').to(action: :create) }
    it { is_expected.to route(:get, '/admin/books/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:patch, '/admin/books/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/admin/books/1').to(action: :destroy, id: 1) }
  end
end

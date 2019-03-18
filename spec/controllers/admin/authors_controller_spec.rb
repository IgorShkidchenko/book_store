require 'rails_helper'

RSpec.describe Admin::AuthorsController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let!(:author) { create(:author) }

    let(:valid_attributes) { attributes_for :author }
    let(:invalid_attributes) { { name: nil } }

    render_views
    login_admin

    describe 'when index' do
      before { get :index }

      it { expect(subject.current_admin_user).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:authors)).to include author }
      it { expect(page).to have_content author.name }
      it { expect(page).to have_content I18n.t('admin.actions.view') }
      it { expect(page).to have_content I18n.t('admin.actions.edit') }
      it { expect(page).to have_content I18n.t('admin.actions.delete') }
    end

    describe 'when new' do
      before { get :new }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'new' }
      it { expect(assigns(:author)).to be_a_new Author }
      it { expect(page).to have_field 'author_name' }
    end

    describe 'when create with valid params' do
      before do |example|
        post :create, params: { author: valid_attributes } unless example.metadata[:skip_before]
      end

      it 'when Author incrases', skip_before: true do
        expect do
          post :create, params: { author: valid_attributes }
        end.to change(Author, :count).by(1)
      end

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:author)).to be_a Author }
      it { expect(assigns(:author)).to be_persisted }
      it { expect(response).to redirect_to admin_author_path(Author.last) }
      it { expect(Author.last.name).to eq valid_attributes[:name] }
    end

    describe 'when create with invalid params' do
      before do |example|
        post :create, params: { author: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:author)).to be_a_new Author }
      it 'when Author does not incrase', skip_before: true do
        expect do
          post :create, params: { author: invalid_attributes }
        end.not_to change(Author, :count)
      end
    end

    describe 'when edit' do
      before { get :edit, params: { id: author.id } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'edit' }
      it { expect(assigns(:author)).to eq author }
      it { expect(page).to have_field('author_name', with: author.name) }
    end

    describe 'when update with valid params' do
      before { put :update, params: { id: author.id, author: valid_attributes } }

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:author)).to eq author }
      it { expect(response).to redirect_to admin_author_path(author) }

      it do
        author.reload
        expect(author.name).to eq valid_attributes[:name]
      end
    end

    describe 'when update with invalid params' do
      before do |example|
        put :update, params: { id: author.id, author: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it 'when author does not update', skip_before: true do
        expect do
          put :update, params: { id: author.id, author: invalid_attributes }
        end.not_to(change { author.reload.name })
      end
    end

    describe 'when show' do
      before { get :show, params: { id: author.id } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'show' }
      it { expect(assigns(:author)).to eq author }
      it { expect(page).to have_content author.name }
    end

    describe 'when destroy' do
      it do
        expect do
          delete :destroy, params: { id: author.id }
        end.to change(Author, :count).by(-1)
      end

      it 'redirects to the field' do
        delete :destroy, params: { id: author.id }
        expect(response).to redirect_to(admin_authors_path)
      end
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/authors').to(action: :index) }
    it { is_expected.to route(:get, '/admin/authors/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/admin/authors/new').to(action: :new) }
    it { is_expected.to route(:post, '/admin/authors').to(action: :create) }
    it { is_expected.to route(:get, '/admin/authors/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:patch, '/admin/authors/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/admin/authors/1').to(action: :destroy, id: 1) }
  end
end

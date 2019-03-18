require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let!(:category) { create(:category) }

    let(:valid_attributes) { attributes_for :category }
    let(:invalid_attributes) { { name: nil } }

    render_views
    login_admin

    describe 'when index' do
      before { get :index }

      it { expect(subject.current_admin_user).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:categories)).to include category }
      it { expect(page).to have_content category.name }
      it { expect(page).to have_content I18n.t('admin.actions.view') }
      it { expect(page).to have_content I18n.t('admin.actions.edit') }
      it { expect(page).to have_content I18n.t('admin.actions.delete') }
    end

    describe 'when new' do
      before { get :new }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'new' }
      it { expect(assigns(:category)).to be_a_new Category }
      it { expect(page).to have_field 'category_name' }
    end

    describe 'when create with valid params' do
      before do |example|
        post :create, params: { category: valid_attributes } unless example.metadata[:skip_before]
      end

      it 'when Category incrases', skip_before: true do
        expect do
          post :create, params: { category: valid_attributes }
        end.to change(Category, :count).by(1)
      end

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:category)).to be_a Category }
      it { expect(assigns(:category)).to be_persisted }
      it { expect(response).to redirect_to admin_category_path(Category.last) }
      it { expect(Category.last.name).to eq valid_attributes[:name] }
    end

    describe 'when create with invalid params' do
      before do |example|
        post :create, params: { category: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:category)).to be_a_new Category }
      it 'when Category does not insrased', skip_before: true do
        expect do
          post :create, params: { category: invalid_attributes }
        end.not_to change(Category, :count)
      end
    end

    describe 'when edit' do
      before { get :edit, params: { id: category.id } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'edit' }
      it { expect(assigns(:category)).to eq category }
      it { expect(page).to have_field('category_name', with: category.name) }
    end

    describe 'when update with valid params' do
      before { put :update, params: { id: category.id, category: valid_attributes } }

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:category)).to eq category }
      it { expect(response).to redirect_to admin_category_path(category) }

      it do
        category.reload
        expect(category.name).to eq valid_attributes[:name]
      end
    end

    describe 'when update with invalid params' do
      before do |example|
        put :update, params: { id: category.id, category: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it 'when category does not update', skip_before: true do
        expect do
          put :update, params: { id: category.id, category: invalid_attributes }
        end.not_to(change { category.reload.name })
      end
    end

    describe 'when show' do
      before { get :show, params: { id: category.id } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'show' }
      it { expect(assigns(:category)).to eq category }
      it { expect(page).to have_content category.name }
    end

    describe 'when destroy' do
      it do
        expect do
          delete :destroy, params: { id: category.id }
        end.to change(Category, :count).by(-1)
      end

      it 'redirects to the field' do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(admin_categories_path)
      end
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/categories').to(action: :index) }
    it { is_expected.to route(:get, '/admin/categories/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/admin/categories/new').to(action: :new) }
    it { is_expected.to route(:post, '/admin/categories').to(action: :create) }
    it { is_expected.to route(:get, '/admin/categories/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:patch, '/admin/categories/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/admin/categories/1').to(action: :destroy, id: 1) }
  end
end

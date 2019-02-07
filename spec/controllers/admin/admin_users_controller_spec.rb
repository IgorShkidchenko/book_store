require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let(:admin) { subject.current_admin_user }

    let(:valid_attributes) { FactoryBot.attributes_for :admin_user }
    let(:invalid_attributes) { { email: nil } }

    render_views
    login_admin

    describe 'when index' do
      before { get :index }

      it { expect(admin).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:admin_users)).to include admin }
      it { expect(page).to have_content admin.email }
      it { expect(page).to have_content admin.current_sign_in_at }
      it { expect(page).to have_content admin.sign_in_count }
      it { expect(page).to have_content admin.created_at.strftime('%B %d, %Y %H:%M') }
      it { expect(page).to have_content I18n.t('admin.actions.view') }
      it { expect(page).to have_content I18n.t('admin.actions.edit') }
      it { expect(page).to have_content I18n.t('admin.actions.delete') }
    end

    describe 'when new' do
      before { get :new }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:admin_user)).to be_a_new AdminUser }
      it { expect(page).to have_field 'admin_user_email' }
      it { expect(page).to have_field 'admin_user_password' }
      it { expect(page).to have_field 'admin_user_password_confirmation' }
    end

    describe 'when create with valid params' do
      before do |example|
        post :create, params: { admin_user: valid_attributes } unless example.metadata[:skip_before]
      end

      it 'when AdminUser incrases', skip_before: true do
        expect do
          post :create, params: { admin_user: valid_attributes }
        end.to change(AdminUser, :count).by(1)
      end

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:admin_user)).to be_a AdminUser }
      it { expect(assigns(:admin_user)).to be_persisted }
      it { expect(response).to redirect_to admin_admin_user_path(AdminUser.last) }
      it { expect(AdminUser.last.email).to eq valid_attributes[:email] }
    end

    describe 'when create with invalid params' do
      before do |example|
        post :create, params: { admin_user: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:admin_user)).to be_a_new AdminUser }
      it 'when AdminUser does not insrased', skip_before: true do
        expect do
          post :create, params: { admin_user: invalid_attributes }
        end.not_to change(AdminUser, :count)
      end
    end

    describe 'when edit' do
      before { get :edit, params: { id: admin.id } }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:admin_user)).to eq admin }
      it { expect(page).to have_field('admin_user_email', with: admin.email) }
    end

    describe 'when update with valid params' do
      before { put :update, params: { id: admin.id, admin_user: valid_attributes } }

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:admin_user)).to eq admin }
      it { expect(response).to redirect_to admin_admin_user_path(admin) }

      it do
        admin.reload
        expect(admin.email).to eq valid_attributes[:email]
      end
    end

    describe 'when update with invalid params' do
      before do |example|
        put :update, params: { id: admin.id, admin_user: invalid_attributes } unless example.metadata[:skip_before]
      end

      it { is_expected.to respond_with 200 }
      it 'when admin does not update', skip_before: true do
        expect do
          put :update, params: { id: admin.id, admin_user: invalid_attributes }
        end.not_to(change { admin.reload.email })
      end
    end

    describe 'when show' do
      before { get :show, params: { id: admin.id } }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:admin_user)).to eq admin }
      it { expect(page).to have_content(admin.email) }
    end

    describe 'when destroy' do
      it do
        expect do
          delete :destroy, params: { id: admin.id }
        end.to change(AdminUser, :count).by(-1)
      end

      it 'redirects to the field' do
        delete :destroy, params: { id: admin.id }
        expect(response).to redirect_to(admin_admin_users_path)
      end
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/admin_users').to(action: :index) }
    it { is_expected.to route(:get, '/admin/admin_users/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get, '/admin/admin_users/new').to(action: :new) }
    it { is_expected.to route(:post, '/admin/admin_users').to(action: :create) }
    it { is_expected.to route(:get, '/admin/admin_users/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:patch, '/admin/admin_users/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/admin/admin_users/1').to(action: :destroy, id: 1) }
  end
end

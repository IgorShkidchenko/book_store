require 'rails_helper'

RSpec.describe Admin::CouponsController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let!(:coupon) { create(:coupon) }

    render_views
    login_admin

    describe 'when index' do
      let(:scope) { { all: 'All', used: 'Used', unused: 'Unused' } }

      before { get :index }

      it { expect(subject.current_admin_user).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:coupons)).to include coupon }
      it { expect(page).to have_content coupon.key }
      it { expect(page).to have_content coupon.discount }
      it { expect(page).to have_content I18n.t('admin.actions.view') }
      it { expect(page).to have_content I18n.t('admin.coupon.generate') }
      it { expect(page).to have_content scope[:all] }
      it { expect(page).to have_content scope[:used] }
      it { expect(page).to have_content scope[:unused] }
    end

    describe 'when show' do
      before { get :show, params: { id: coupon.id } }

      it { is_expected.to respond_with 200 }
      it { expect(assigns(:coupon)).to eq coupon }
      it { is_expected.to render_template 'show' }
      it { expect(page).to have_content coupon.key }
      it { expect(page).to have_content coupon.discount }
    end

    describe 'when create' do
      before do |example|
        post :create, params: { coupon: { key: coupon.key.succ } } unless example.metadata[:skip_before]
      end

      it 'when Coupon incrases', skip_before: true do
        expect do
          post :create, params: { coupon: { key: coupon.key.succ } }
        end.to change(Coupon, :count).by(1)
      end

      it { is_expected.to respond_with 302 }
      it { expect(assigns(:coupon)).to be_a Coupon }
      it { expect(assigns(:coupon)).to be_persisted }
      it { expect(response).to redirect_to admin_coupon_path(Coupon.last) }
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/coupons').to(action: :index) }
    it { is_expected.to route(:get, '/admin/coupons/1').to(action: :show, id: 1) }
    it { is_expected.to route(:post, '/admin/coupons').to(action: :create) }
  end
end

require 'rails_helper'

RSpec.describe Admin::OrdersController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let!(:order) { create(:order_in_checkout_final_steps, :in_progress).decorate }

    render_views
    login_admin

    describe 'when index' do
      before { get :index }

      it { expect(subject.current_admin_user).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:orders)).to include order.order }
      it { expect(page).to have_content order.number }
      it { expect(page).to have_content order.total_price }
      it { expect(page).to have_content order.creation_date }
      it { expect(page).to have_content order.status }
      it { expect(page).to have_content I18n.t('admin.order.status') }
      it { expect(page).to have_content I18n.t('cart.page.order_total') }
      it { expect(page).to have_content I18n.t('admin.order.status') }
      it { expect(page).to have_content I18n.t('admin.batches.in_queue') }
      it { expect(page).to have_content I18n.t('admin.batches.in_delivery') }
      it { expect(page).to have_content I18n.t('admin.batches.delivered') }
      it { expect(page).to have_content I18n.t('admin.batches.canceled') }
    end

    describe 'when show' do
      before { get :show, params: { id: order.id } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'show' }
      it { expect(assigns(:order)).to eq order.order }
      it { expect(page).to have_content order.number }
      it { expect(page).to have_content order.delivery_method.name }
      it { expect(page).to have_content order.user.email }
      it { expect(page).to have_content Order.aasm_states.key(4).to_s }
    end

    describe 'when batch actions' do
      before { post :batch_action, params: { batch_action: action, collection_selection: [order.id] } }

      context 'when in_queue' do
        let(:action) { Order.aasm_states.key(5) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to admin_orders_path }

        it do
          order.reload
          expect(order.in_queue?).to eq true
        end
      end

      context 'when in_delivery' do
        let(:order) { create(:order_in_checkout_final_steps, :in_queue) }
        let(:action) { Order.aasm_states.key(6) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to admin_orders_path }

        it do
          order.reload
          expect(order.in_delivery?).to eq true
        end
      end

      context 'when delivered' do
        let(:order) { create(:order_in_checkout_final_steps, :in_delivery) }
        let(:action) { Order.aasm_states.key(7) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to admin_orders_path }

        it do
          order.reload
          expect(order.delivered?).to eq true
        end
      end

      context 'when canceled' do
        let(:action) { Order.aasm_states.key(8) }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to admin_orders_path }

        it do
          order.reload
          expect(order.canceled?).to eq true
        end
      end
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/orders').to(action: :index) }
    it { is_expected.to route(:get, '/admin/orders/1').to(action: :show, id: 1) }
  end
end

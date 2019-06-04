require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:order) { create(:order_in_checkout_final_steps, :delivered) }
  let(:user) { order.user }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe 'when #show' do
    before do
      allow(Orders::OrderItemsQuery).to receive(:call).and_return([order])
      allow(OrdersOfUserPresenter).to receive(:new)
      get :show, params: { id: order.id }
    end

    it { is_expected.to render_template 'show' }
    it { is_expected.to respond_with 200 }
    it { expect(assigns(:order)).to eq order }
  end

  describe 'when #index' do
    before do
      allow(Orders::FilterQuery).to receive(:call).and_return([order])
      get :index, params: { user_id: user.id }
    end

    it { is_expected.to render_template 'index' }
    it { is_expected.to respond_with 200 }
    it { expect(assigns(:orders)).to include order }
  end

  describe 'when routes' do
    it { is_expected.to route(:get, "/orders/#{order.id}").to(action: :show, id: order.id) }
    it { is_expected.to route(:get, "users/#{user.id}/orders").to(action: :index, user_id: user.id) }
  end
end

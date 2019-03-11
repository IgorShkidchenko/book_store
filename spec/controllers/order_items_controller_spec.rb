require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  let(:order_item) { FactoryBot.create(:order_item) }
  let(:order) { order_item.order }

  before do
    allow(Order).to receive(:find).and_return(order)
    allow(OrderItems::NewCartItemService).to receive(:call)
  end

  describe 'when create' do
    let(:valid_params) { (FactoryBot.attributes_for :order_item).merge(order_id: order_item.order_id) }

    before { post :create, xhr: true, params: { order_item: valid_params } }

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template 'create' }
  end

  describe 'when update' do
    before do
      allow(OrderItem).to receive(:find).and_return(order_item)
      allow(OrderItems::QuantityUpdaterService).to receive(:call)
      put :update, xhr: true, params: { id: order_item.id, order_item: { command: nil } }
    end

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template 'update' }
  end

  describe 'when destroy' do
    before do
      allow(OrderItem).to receive(:find).and_return(order_item)
      delete :destroy, xhr: true, params: { id: order_item.id }
    end

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template 'destroy' }
  end

  describe 'when routes' do
    it { is_expected.to route(:post, '/order_items').to(action: :create) }
    it { is_expected.to route(:put, '/order_items/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete, '/order_items/1').to(action: :destroy, id: 1) }
  end
end

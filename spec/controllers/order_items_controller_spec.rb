require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  let(:order_item) { create(:order_item) }
  let(:order) { order_item.order }

  describe 'when #index' do
    before do
      allow(Orders::OrderItemsQuery).to receive_message_chain(:call, :decorate).and_return([order_item])
      get :index, params: { order_id: order.id }
    end

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template 'index' }
    it { expect(assigns(:order_items)).to include order_item }
  end

  describe 'when #create' do
    let(:params) { (attributes_for :order_item).merge(order_id: order.id) }

    context 'when valid' do
      before do
        allow(OrderItems::NewCartItemService).to receive(:call).and_return(true)
        post :create, xhr: true, params: { order_item: params }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'create' }
      it { is_expected.not_to set_flash.now[:danger].to I18n.t('cart.errors.unknow') }
    end

    context 'when invalid' do
      before do
        allow(OrderItems::NewCartItemService).to receive(:call).and_return(false)
        post :create, xhr: true, params: { order_item: params }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'create' }
      it { is_expected.to set_flash.now[:danger].to I18n.t('cart.errors.unknow') }
    end
  end

  describe 'when #update' do
    before { allow(OrderItem).to receive(:find).and_return(order_item) }

    context 'when valid' do
      before do
        allow(OrderItems::QuantityUpdaterService).to receive(:call).and_return(true)
        put :update, xhr: true, params: { id: order_item.id }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'update' }
      it { expect(assigns(:order_item)).to eq order_item }
      it { is_expected.not_to set_flash.now[:danger].to I18n.t('cart.errors.min_quantity') }
    end

    context 'when invalid' do
      before do
        allow(OrderItems::QuantityUpdaterService).to receive(:call).and_return(false)
        put :update, xhr: true, params: { id: order_item.id }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'update' }
      it { expect(assigns(:order_item)).to eq order_item }
      it { is_expected.to set_flash.now[:danger].to I18n.t('cart.errors.min_quantity') }
    end
  end

  describe 'when #destroy' do
    before { allow(OrderItem).to receive(:find).and_return(order_item) }

    context 'when valid' do
      before do
        allow_any_instance_of(OrderItem).to receive(:destroy).and_return(true)
        delete :destroy, xhr: true, params: { id: order_item.id }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'destroy' }
      it { expect(assigns(:order_item)).to eq order_item }
      it { is_expected.not_to set_flash.now[:danger].to I18n.t('cart.errors.unknow') }
    end

    context 'when invalid' do
      before do
        allow_any_instance_of(OrderItem).to receive(:destroy).and_return(false)
        delete :destroy, xhr: true, params: { id: order_item.id }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'destroy' }
      it { expect(assigns(:order_item)).to eq order_item }
      it { is_expected.to set_flash.now[:danger].to I18n.t('cart.errors.unknow') }
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, "/orders/#{order.id}/order_items").to(action: :index, order_id: order.id) }
    it { is_expected.to route(:post, '/order_items').to(action: :create) }
    it { is_expected.to route(:put, "/order_items/#{order_item.id}").to(action: :update, id: order_item.id) }
    it { is_expected.to route(:delete, "/order_items/#{order_item.id}").to(action: :destroy, id: order_item.id) }
  end
end

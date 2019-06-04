require 'rails_helper'

RSpec.describe OrderItems::NewCartItemService do
  subject(:new_cart_item_service_call) { described_class.call(params: params, order: order) }

  let(:order) { build(:order) }
  let(:order_item) { create(:order_item) }
  let(:random_number) { '1' }
  let(:params) { { book_id: order_item.book.id, quantity: random_number } }

  context 'when #update_quantity' do
    before { allow(order).to receive_message_chain(:order_items, :find_by).and_return(order_item) }

    it do
      expect(order_item).to receive(:update).with(quantity: (order_item.quantity + params[:quantity].to_i))
      new_cart_item_service_call
    end
    it { expect { new_cart_item_service_call }.to change(order_item, :quantity).by(1) }
    it { expect(new_cart_item_service_call).to eq true }
  end

  context 'when #create_new_item' do
    before { allow(order).to receive_message_chain(:order_items, :find_by).and_return(nil) }

    it do
      expect do
        expect(order).to receive_message_chain(:order_items, :create).with(params)
        new_cart_item_service_call
      end.to change(OrderItem, :count).by(1)
    end
  end
end

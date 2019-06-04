require 'rails_helper'

RSpec.describe Orders::PriceCalculatorService do
  subject(:price_calculator_service) { described_class.new(order) }

  let(:order) { create(:order_in_checkout_form_steps, :payment_step, :with_coupon) }
  let(:subtotal_result) { order.order_items.sum { |item| item.book_price * item.quantity } }
  let(:total_result) { subtotal_result - order.coupon.discount + order.delivery_method.cost }

  it 'when #subtotal_price' do
    expect(price_calculator_service.subtotal_price).to eq subtotal_result
  end

  it 'when #total_price' do
    expect(price_calculator_service.total_price).to eq total_result
  end
end

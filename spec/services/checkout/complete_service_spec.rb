require 'rails_helper'

RSpec.describe Checkout::CompleteService do
  subject(:complete_service) { described_class }

  let(:generated_number) { Checkout::CompleteService::FIRST_ORDER_NUMBER_SYMBOL + fake_time }
  let(:fake_time) { 'time' }
  let(:order) { build(:order_in_checkout_final_steps, :confirm_step) }
  let(:coupon) { build(:coupon) }

  before do
    allow(Time).to receive_message_chain(:now, :strftime).and_return(fake_time)
    allow(OrderConfirmationMailerWorker).to receive(:perform_async)
    allow(order).to receive(:coupon).and_return(coupon)
  end

  it 'when #call' do
    expect(order).to receive(:in_progress!)
    expect(order).to receive(:update).with(number: generated_number)
    expect(order.coupon).to receive(:update).with(used: true)
    expect(OrderConfirmationMailerWorker).to receive(:perform_async).with(order.id)
    complete_service.call(order)
  end
end

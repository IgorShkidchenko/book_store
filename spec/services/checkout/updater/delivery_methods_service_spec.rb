require 'rails_helper'

RSpec.describe Checkout::Updater::DeliveryMethodsService do
  subject(:delivery_methods_service) { described_class.new(order: order, params: params) }

  let(:order) { build(:order_in_checkout_form_steps, :delivery_step) }
  let(:some_id) { rand(1..10) }
  let(:params) { { delivery_method_id: some_id } }

  describe 'when #call valid' do
    it do
      allow(DeliveryMethod).to receive_message_chain(:where, :exists?).and_return(true)
      expect(order).to receive(:update).with(delivery_method_id: some_id)
      expect(order).to receive(:fill_payment!)
      delivery_methods_service.call
    end
  end

  describe 'when #call invalid' do
    it do
      allow(DeliveryMethod).to receive_message_chain(:where, :exists?).and_return(false)
      expect(DeliveryMethod).to receive(:all)
      delivery_methods_service.call
    end
  end
end

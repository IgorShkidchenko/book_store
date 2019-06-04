require 'rails_helper'

RSpec.describe Checkout::FormVariablesService do
  subject(:form_variables_service) { described_class.new(order: order) }

  let(:order) { build(:order_in_checkout_final_steps, :confirm_step) }

  context 'when #set_addresses_variables' do
    it do
      expect(form_variables_service).to receive(:set_addresses_variables)
      form_variables_service.call(CheckoutStepsController::STEPS[:address])
    end
  end

  context 'when #set_delivery_variable' do
    it do
      expect(form_variables_service).to receive(:set_delivery_variable)
      form_variables_service.call(CheckoutStepsController::STEPS[:delivery])
    end
  end

  context 'when #set_credit_card_variable' do
    it do
      expect(form_variables_service).to receive(:set_credit_card_variable)
      form_variables_service.call(CheckoutStepsController::STEPS[:payment])
    end
  end
end

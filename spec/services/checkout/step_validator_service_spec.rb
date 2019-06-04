require 'rails_helper'

RSpec.describe Checkout::StepValidatorService do
  subject(:step_validator_service) { described_class.new(order: order, step: step, authenticate: user_sign_in?) }

  let(:user_sign_in?) { true }
  let(:order) { nil }
  let(:step) { nil }

  context 'when check authenticate step' do
    let(:user_sign_in?) { false }

    it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:authenticate] }
  end

  context 'when check address step' do
    let(:order) { build(:order) }

    it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:address] }
  end

  context 'when check delivery step' do
    let(:order) { build(:order_in_checkout_form_steps, :delivery_step) }

    it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:delivery] }
  end

  context 'when check payment step' do
    let(:order) { build(:order_in_checkout_form_steps, :payment_step) }

    it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:payment] }
  end

  describe 'when check edit step' do
    let!(:order) { build(:order_in_checkout_final_steps, :confirm_step) }

    context 'when go to authenticate step' do
      let(:step) { CheckoutStepsController::STEPS[:authenticate] }

      it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:edit] }
    end

    context 'when go to address step' do
      let(:step) { CheckoutStepsController::STEPS[:address] }

      it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:address] }
    end

    context 'when go to delivery step' do
      let(:step) { CheckoutStepsController::STEPS[:delivery] }

      it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:delivery] }
    end

    context 'when go to payment step' do
      let(:step) { CheckoutStepsController::STEPS[:payment] }

      it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:payment] }
    end

    context 'when go to complete step' do
      let(:step) { CheckoutStepsController::STEPS[:complete] }

      it { expect(step_validator_service.call).to eq CheckoutStepsController::STEPS[:complete] }
    end
  end

  describe 'when #valid?' do
    let(:order) { build(:order) }

    context 'when valid' do
      let(:step) { CheckoutStepsController::STEPS[:address] }

      it do
        step_validator_service.call
        expect(step_validator_service.valid?).to eq true
      end
    end

    context 'when invalid' do
      let(:step) { CheckoutStepsController::STEPS[:complete] }

      it do
        step_validator_service.call
        expect(step_validator_service.valid?).to eq false
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Checkout::DelegatorService do
  subject(:delegator_service) { described_class.new(order: order, step: step) }

  let(:order) { nil }
  let(:step) { nil }

  describe 'when #cart_empty?' do
    context 'when valid' do
      let(:order) { create(:order, :with_order_items) }

      it { expect(delegator_service.cart_empty?).to eq false }
    end

    context 'when invalid' do
      let(:order) { build(:order) }

      it { expect(delegator_service.cart_empty?).to eq true }
    end
  end

  describe 'when #step_valid?' do
    let(:result) { delegator_service.step_valid?(nil) }

    context 'when valid' do
      it do
        allow_any_instance_of(Checkout::StepValidatorService).to receive(:valid?).and_return(true)
        expect(result).to eq true
      end
    end

    context 'when invalid' do
      it do
        allow_any_instance_of(Checkout::StepValidatorService).to receive(:valid?).and_return(false)
        expect(result).to eq false
      end
    end
  end

  describe 'when #update' do
    let(:form) { double('Checkout::Updater::Service') }

    context 'when address' do
      let(:step) { CheckoutStepsController::STEPS[:address] }

      it do
        allow(Checkout::Updater::AddressesService).to receive(:new).and_return(form)
        expect(form).to receive(:call)
        expect(form).to receive(:valid?)
        delegator_service.update(nil)
      end
    end

    context 'when delivery' do
      let(:step) { CheckoutStepsController::STEPS[:delivery] }

      it do
        allow(Checkout::Updater::DeliveryMethodsService).to receive(:new).and_return(form)
        expect(form).to receive(:call)
        expect(form).to receive(:valid?)
        delegator_service.update(nil)
      end
    end

    context 'when payment' do
      let(:step) { CheckoutStepsController::STEPS[:payment] }

      it do
        allow(Checkout::Updater::CreditCardsService).to receive(:new).and_return(form)
        expect(form).to receive(:call)
        expect(form).to receive(:valid?)
        delegator_service.update(nil)
      end
    end
  end

  describe 'when #show' do
    context 'when authenticate' do
      let(:step) { CheckoutStepsController::STEPS[:authenticate] }

      it { expect(delegator_service.show).to eq nil }
    end

    context 'when edit' do
      let(:step) { CheckoutStepsController::STEPS[:edit] }

      before { allow(Orders::OrderItemsQuery).to receive_message_chain(:call, :decorate) }

      it do
        expect(delegator_service).to receive(:set_order_items)
        delegator_service.show
      end
    end

    context 'when complete' do
      let(:step) { CheckoutStepsController::STEPS[:complete] }

      it do
        allow(Checkout::CompleteService).to receive(:call)
        expect(delegator_service).to receive(:complete_checkout)
        delegator_service.show
      end
    end

    context 'when forms steps' do
      let(:form) { double('Checkout::FormVariablesService') }

      before { allow(Checkout::FormVariablesService).to receive(:new).and_return(form) }

      context 'when address' do
        let(:step) { CheckoutStepsController::STEPS[:address] }

        it do
          expect(form).to receive(:call).with(step)
          delegator_service.show
        end
      end

      context 'when address' do
        let(:step) { CheckoutStepsController::STEPS[:delivery] }

        it do
          expect(form).to receive(:call).with(step)
          delegator_service.show
        end
      end

      context 'when address' do
        let(:step) { CheckoutStepsController::STEPS[:payment] }

        it do
          expect(form).to receive(:call).with(step)
          delegator_service.show
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe CheckoutStepsController, type: :controller do
  let(:order) { build(:order) }

  before { allow(controller).to receive(:current_order).and_return(order) }

  describe 'when valid' do
    before { allow(controller).to receive(:validate_step) }

    context 'when #show' do
      before { allow_any_instance_of(Checkout::DelegatorService).to receive(:show) }

      CheckoutStepsController::STEPS.each_value do |value|
        it do
          get :show, params: { id: value }
          expect(subject).to respond_with(200)
          expect(subject).to render_template value.to_s
        end
      end
    end

    context 'when #update' do
      before { allow_any_instance_of(Checkout::DelegatorService).to receive(:update) }

      [CheckoutStepsController::STEPS[:address],
       CheckoutStepsController::STEPS[:delivery],
       CheckoutStepsController::STEPS[:payment]].each do |step|
        it do
          put :update, params: { id: step, order: { clone_address: true } }
          expect(subject).to respond_with(200)
          expect(subject).to render_template step.to_s
        end
      end
    end
  end

  describe 'when invalid' do
    it 'when cart is empty' do
      allow_any_instance_of(Checkout::DelegatorService).to receive(:cart_empty?).and_return(true)
      get :show, params: { id: CheckoutStepsController::STEPS[:address] }
      expect(subject).to redirect_to books_path
    end

    context 'when redirect to correct step' do
      before do
        allow(controller).to receive(:show)
        allow_any_instance_of(Checkout::DelegatorService).to receive(:cart_empty?).and_return(false)
        allow_any_instance_of(Checkout::DelegatorService).to receive(:step_valid?).and_return(false)
        allow_any_instance_of(Checkout::DelegatorService).to receive_message_chain(:step_validator,
                                                                                   :correct_step).and_return(CheckoutStepsController::STEPS[:authenticate])
        get :show, params: { id: CheckoutStepsController::STEPS[:address] }
      end

      it { is_expected.to redirect_to checkout_step_path(CheckoutStepsController::STEPS[:authenticate]) }
      it { is_expected.to set_flash[:info].to I18n.t('checkout.follow_steps') }
    end
  end
end

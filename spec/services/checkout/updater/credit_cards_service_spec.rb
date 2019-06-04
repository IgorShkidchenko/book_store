require 'rails_helper'

RSpec.describe Checkout::Updater::CreditCardsService do
  subject(:credit_cards_service) { described_class.new(order: order, params: params) }

  let(:order) { build(:order_in_checkout_form_steps, :payment_step) }
  let(:params) { { credit_card: nil } }

  describe 'when #call valid' do
    before { allow(credit_cards_service).to receive(:credit_card_valid?).and_return(true) }

    it do
      expect(CreditCardForm).to receive(:new).with(params[:credit_card])
      credit_cards_service.call
    end

    it do
      expect(order).to receive(:editing!)
      credit_cards_service.call
    end
  end

  it 'when #call invalid' do
    allow_any_instance_of(CreditCardForm).to receive(:save).and_return(false)
    expect(order).not_to receive(:editing!)
    credit_cards_service.call
  end
end

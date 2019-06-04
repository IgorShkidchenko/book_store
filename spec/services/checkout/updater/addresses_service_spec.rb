require 'rails_helper'

RSpec.describe Checkout::Updater::AddressesService do
  subject(:addresses_service) { described_class.new(order: order, params: params) }

  let(:order) { build(:order) }
  let(:params) { { billing: nil, shipping: nil } }

  describe 'when #call valid' do
    before { allow(addresses_service).to receive(:addresses_valid?).and_return(true) }

    it 'with out cloned params' do
      expect(AddressForm).to receive(:new).with(params[:billing])
      expect(AddressForm).to receive(:new).with(params[:shipping])
      addresses_service.call
    end

    context 'with cloned params' do
      let(:params) { { billing: { kind: nil }, shipping: nil, clone_address: true } }

      it do
        expect(AddressForm).to receive(:new).with(params[:billing]).twice
        addresses_service.call
      end
    end

    it do
      expect(order).to receive(:fill_delivery!)
      addresses_service.call
    end
  end

  it 'when #call invalid' do
    allow(addresses_service).to receive(:addresses_valid?).and_return(false)
    expect(order).not_to receive(:fill_delivery!)
    addresses_service.call
  end
end

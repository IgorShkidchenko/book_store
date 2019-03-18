require 'rails_helper'

RSpec.describe OrderItems::QuantityUpdaterService do
  subject(:quantity_updater_service_call) { described_class.call(params: params, item: order_item) }

  let(:params) { nil }
  let(:order_item) { nil }

  context 'when #increment' do
    let(:params) { { order_item: { command: OrderItems::QuantityUpdaterService::ADD_COMMAND } } }
    let(:order_item) { build(:order_item) }

    it { expect(quantity_updater_service_call).to eq true }
    it { expect { quantity_updater_service_call }.to change(order_item, :quantity).by(1) }
    it do
      expect(order_item).to receive(:increment!).with(:quantity)
      quantity_updater_service_call
    end
  end

  context 'when #decrement' do
    let(:params) { { order_item: { command: nil } } }
    let(:order_item) { build(:order_item) }

    it { expect(quantity_updater_service_call).to eq true }
    it { expect { quantity_updater_service_call }.to change(order_item, :quantity).by(-1) }
    it do
      expect(order_item).to receive(:decrement!).with(:quantity)
      quantity_updater_service_call
    end
  end

  context 'when quantity eq min allowed quantity' do
    let(:params) { { order_item: { command: nil } } }
    let(:order_item) { build(:order_item, :with_min_quantity) }

    it { expect { quantity_updater_service_call }.to change(order_item, :quantity).by(0) }
    it { expect(quantity_updater_service_call).to eq false }
  end
end

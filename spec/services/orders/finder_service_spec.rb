require 'rails_helper'

RSpec.describe Orders::FinderService do
  subject(:finder_service) { described_class }

  let(:complete_order) { build(:order_in_checkout_final_steps, :delivered) }
  let(:order) { build(:order) }
  let(:user) { build(:user) }

  it 'when order in checkout state' do
    allow(Order).to receive(:find_by).and_return(order)
    expect(finder_service.call(order, user)).to eq order
  end

  it 'when order in progress state' do
    allow(Order).to receive(:find_by).and_return(complete_order)
    expect(Order).to receive(:new).with(user: user)
    finder_service.call(complete_order, user)
  end

  it 'when order is nil' do
    allow(Order).to receive(:find_by).and_return(nil)
    expect(Order).to receive(:new).with(user: user)
    finder_service.call(nil, user)
  end
end

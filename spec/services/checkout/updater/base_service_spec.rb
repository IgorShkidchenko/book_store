require 'rails_helper'

RSpec.describe Checkout::Updater::BaseService do
  subject(:base_service) { described_class.new(order: nil, params: nil) }

  it 'when call raise error' do
    expect { base_service.call }.to raise_error NotImplementedError
  end

  it 'when #valid? true' do
    expect(base_service.valid?(true)).to eq true
  end

  it 'when #valid? false' do
    expect(base_service.valid?(false)).to eq false
  end
end

require 'rails_helper'

RSpec.describe Coupons::KeyGeneratorService do
  subject(:key_generator_service) { described_class }

  let(:fake_time) { 'time' }
  let(:fake_hex) { 'hex' }
  let(:result) { fake_time + fake_hex }

  before do
    allow(Time).to receive_message_chain(:now, :strftime).and_return(fake_time)
    allow(SecureRandom).to receive(:hex).and_return(fake_hex)
  end

  it 'check loop' do
    allow(Coupon).to receive_message_chain(:where, :exists?).and_return(true, true, false)
    expect(SecureRandom).to receive(:hex).exactly(3).times
    key_generator_service.call
  end

  it 'check result' do
    allow(Coupon).to receive_message_chain(:where, :exists?).and_return(false)
    expect(key_generator_service.call).to eq result
  end
end

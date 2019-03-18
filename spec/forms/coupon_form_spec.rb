require 'rails_helper'

RSpec.describe CouponForm, type: :model do
  subject(:coupon_form) { described_class.new(params) }

  let(:order) { create(:order) }

  before { coupon_form.save(order) }

  context 'with not existing key' do
    let(:params) { { key: nil } }

    it { expect(coupon_form.errors.full_messages.to_sentence).to eq I18n.t('coupon.error_havent') }
    it { expect(order.coupon).to eq nil }
  end

  context 'when coupon was already used' do
    let(:used_coupon) { create(:coupon, :used) }
    let(:params) { { key: used_coupon.key } }

    it { expect(coupon_form.errors.full_messages.to_sentence).to eq I18n.t('coupon.error_used') }
    it { expect(order.coupon).to eq nil }
  end

  context 'when valid coupon' do
    let(:coupon) { create(:coupon) }
    let(:params) { { key: coupon.key } }

    it { expect(order.coupon).to eq coupon }
  end
end

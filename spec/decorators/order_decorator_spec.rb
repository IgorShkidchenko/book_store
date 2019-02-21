require 'rails_helper'

RSpec.describe OrderDecorator do
  describe 'when coupon_discount' do
    context 'with coupon' do
      let(:order) { FactoryBot.create(:order, :with_coupon).decorate }

      it { expect(order.decorate.coupon_discount).to eq I18n.t('price', price: order.coupon.discount) }
    end

    context 'without coupon' do
      let(:order) { FactoryBot.create(:order).decorate }

      it { expect(order.coupon_discount).to eq OrderDecorator::ZERO_AMOUNT }
    end
  end
end

require 'rails_helper'

RSpec.describe CouponsController, type: :controller do
  let(:coupon) { create(:coupon) }
  let(:order) { create(:order) }

  describe 'when update with valid params' do
    before do
      allow(controller).to receive(:current_order).and_return(order)
      put :update, xhr: true, params: { id: :coupon, coupon: { key: coupon.key } }
    end

    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template 'update' }
    it { expect(order.coupon).to eq coupon }
  end

  describe 'when update with invalid params' do
    context 'with not_existing_key' do
      let(:not_existing_key) { 'some_key' }

      before do
        put :update, xhr: true, params: { id: :coupon, coupon: { key: not_existing_key } }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'update' }
      it { expect(flash[:danger]).to eq I18n.t('coupon.error_havent') }
      it { expect(order.coupon).to eq nil }
    end

    context 'when coupon was already used' do
      let(:used_coupon) { create(:coupon, :used) }

      before do
        put :update, xhr: true, params: { id: :used_coupon, coupon: { key: used_coupon.key } }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'update' }
      it { expect(flash[:danger]).to eq I18n.t('coupon.error_used') }
      it { expect(order.coupon).to eq nil }
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:put, '/coupons/1').to(action: :update, id: 1) }
  end
end

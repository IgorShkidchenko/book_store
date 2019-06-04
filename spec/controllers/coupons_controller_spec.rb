require 'rails_helper'

RSpec.describe CouponsController, type: :controller do
  let(:some_id) { rand(1..10) }

  describe 'when #update' do
    context 'with valid params' do
      before do
        allow_any_instance_of(CouponForm).to receive(:save).and_return(true)
        put :update, xhr: true, params: { id: some_id, coupon: { key: nil } }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'update' }
      it { is_expected.not_to set_flash.now[:danger] }
    end

    context 'with invalid params' do
      let(:error) { I18n.t('coupon.error_havent') }

      before do
        allow_any_instance_of(CouponForm).to receive(:save).and_return(false)
        allow_any_instance_of(CouponForm).to receive_message_chain(:errors, :full_messages, :to_sentence).and_return(error)
        put :update, xhr: true, params: { id: some_id, coupon: { key: nil } }
      end

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'update' }
      it { is_expected.to set_flash.now[:danger].to error }
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:put, "/coupons/#{some_id}").to(action: :update, id: some_id) }
  end
end

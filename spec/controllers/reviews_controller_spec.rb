require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe 'when #create' do
    let(:user) { create(:user) }
    let(:params) { attributes_for(:review) }

    before { allow(controller).to receive(:current_user).and_return(user) }

    context 'when valid' do
      before do
        allow_any_instance_of(ReviewForm).to receive(:save).and_return(true)
        post :create, xhr: true, params: { review_form: params }
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template 'create' }
      it { is_expected.to set_flash.now[:success].to I18n.t('review.success_msg') }
    end

    context 'when invalid' do
      let(:error) { I18n.t('review.validation_format_msg') }

      before do
        allow_any_instance_of(ReviewForm).to receive(:save).and_return(false)
        allow_any_instance_of(ReviewForm).to receive_message_chain(:errors, :full_messages, :to_sentence).and_return(error)
        post :create, xhr: true, params: { review_form: params }
      end

      it { is_expected.to respond_with(200) }
      it { is_expected.to render_template 'create' }
      it { is_expected.to set_flash.now[:danger].to error }
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:post, '/reviews').to(action: :create) }
  end
end

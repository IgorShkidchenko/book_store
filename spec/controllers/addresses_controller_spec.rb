require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
  let(:some_id) { 1 }
  let(:user) { create(:user) }
  let(:params) { attributes_for(:address, :billing) }

  before { allow(controller).to receive(:current_user).and_return(user) }

  describe 'when valid' do
    let(:address_kind) { Address.kinds.key(params[:kind]).capitalize }

    before { allow_any_instance_of(AddressForm).to receive(:save).and_return(true) }

    context 'when #create' do
      before { post :create, xhr: true, params: { address_form: params } }

      it do
        is_expected.to respond_with(200)
        is_expected.to render_template 'create'
        is_expected.to set_flash.now[:success].to I18n.t('user_settings.success', kind: address_kind)
      end
    end

    context 'when #update' do
      before { put :update, xhr: true, params: { id: some_id, address_form: params } }

      it do
        is_expected.to respond_with(200)
        is_expected.to render_template 'update'
        is_expected.to set_flash.now[:success].to I18n.t('user_settings.success', kind: address_kind)
      end
    end
  end

  describe 'when invalid' do
    let(:error) { I18n.t('checkout.errors.only_letters') }

    before do
      allow_any_instance_of(AddressForm).to receive(:save).and_return(false)
      allow_any_instance_of(AddressForm).to receive_message_chain(:errors, :full_messages, :to_sentence).and_return(error)
    end

    context 'when #create' do
      before { post :create, xhr: true, params: { address_form: params } }

      it do
        is_expected.to respond_with(200)
        is_expected.to render_template 'create'
        is_expected.to set_flash.now[:danger].to error
      end
    end

    context 'when #update' do
      before { put :update, xhr: true, params: { id: some_id, address_form: params } }

      it do
        is_expected.to respond_with(200)
        is_expected.to render_template 'update'
        is_expected.to set_flash.now[:danger].to error
      end
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:post, '/addresses').to(action: :create) }
    it { is_expected.to route(:put, "/addresses/#{some_id}").to(action: :update, id: some_id) }
  end
end

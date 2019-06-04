require 'rails_helper'

RSpec.describe AddressForm, type: :model do
  let(:valid_input) { 'text text' }
  let(:invalid_input) { '@' }
  let(:address_valid_input) { "text 0-9'`\"-" }
  let(:phone_valid_input) { '+30971234567' }
  let(:phone_invalid_input) { '30971234567' }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:street) }
  it { is_expected.to validate_presence_of(:zip) }
  it { is_expected.to validate_presence_of(:phone) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(AddressForm::TEXT_FIELD_MAX_LENGHT) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(AddressForm::TEXT_FIELD_MAX_LENGHT) }
  it { is_expected.to validate_length_of(:country).is_at_most(AddressForm::TEXT_FIELD_MAX_LENGHT) }
  it { is_expected.to validate_length_of(:city).is_at_most(AddressForm::TEXT_FIELD_MAX_LENGHT) }
  it { is_expected.to validate_length_of(:street).is_at_most(AddressForm::TEXT_FIELD_MAX_LENGHT) }
  it { is_expected.to validate_length_of(:zip).is_at_most(AddressForm::ZIP_MAX_LENGHT) }
  it { is_expected.to validate_length_of(:phone).is_at_most(AddressForm::PHONE_MAX_LENGHT) }
  it { is_expected.to allow_value(valid_input).for(:first_name).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.to allow_value(valid_input).for(:last_name).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.to allow_value(valid_input).for(:country).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.to allow_value(valid_input).for(:city).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.to allow_value(address_valid_input).for(:street).with_message(I18n.t('checkout.errors.address')) }
  it { is_expected.to allow_value(phone_valid_input).for(:phone).with_message(I18n.t('checkout.errors.phone')) }
  it { is_expected.not_to allow_value(invalid_input).for(:first_name).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.not_to allow_value(invalid_input).for(:last_name).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.not_to allow_value(invalid_input).for(:country).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.not_to allow_value(invalid_input).for(:city).with_message(I18n.t('checkout.errors.only_letters')) }
  it { is_expected.not_to allow_value(invalid_input).for(:street).with_message(I18n.t('checkout.errors.address')) }
  it { is_expected.not_to allow_value(phone_invalid_input).for(:phone).with_message(I18n.t('checkout.errors.phone')) }

  context 'when addresses #save' do
    subject(:address_form) { described_class.new(params) }

    let(:params) { attributes_for(:address, :billing) }
    let(:order) { create(:order) }

    it 'when successfuly' do
      address_form.save(order)
      expect(order.addresses.billing.first.last_name).to eq params[:last_name]
    end

    it 'when failed' do
      allow(address_form).to receive(:valid?).and_return(false)
      address_form.save(order)
      expect(order.addresses.billing.first).to eq nil
    end
  end
end

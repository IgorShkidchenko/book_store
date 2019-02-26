require 'rails_helper'

RSpec.describe CreditCardForm, type: :model do
  context 'with out past validate expire date' do
    let(:valid_input) { 'text text' }
    let(:invalid_input) { '@' }
    let(:invalid_date) { '1/1' }

    before { allow_any_instance_of(ValidExpireDateValidator).to receive(:validate_each) }

    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:expire_date) }
    it { is_expected.to validate_presence_of(:cvv) }
    it { is_expected.to validate_length_of(:number).is_equal_to(CreditCardForm::NUMBER_LENGTH) }
    it { is_expected.to validate_length_of(:name).is_at_most(CreditCardForm::NAME_MAX_LENGTH) }
    it { is_expected.to validate_length_of(:cvv).is_at_least(CreditCardForm::CVV_RANGE.min).is_at_most(CreditCardForm::CVV_RANGE.max) }
    it { is_expected.to validate_numericality_of(:number).only_integer.with_message(I18n.t('checkout.errors.only_numbers')) }
    it { is_expected.to allow_value(valid_input).for(:name).with_message(I18n.t('checkout.errors.only_letters')) }
    it { is_expected.not_to allow_value(invalid_input).for(:name).with_message(I18n.t('checkout.errors.only_letters')) }
    it { is_expected.not_to allow_value(invalid_input).for(:expire_date).with_message(I18n.t('checkout.errors.expire_date')) }
  end

  context 'with past validate expire date' do
    let(:valid_date) { "12/#{Time.now.year - ValidExpireDateValidator::CENTURY}" }
    let(:month_in_the_past) { "0#{Time.now.month - 1}/#{Time.now.year - ValidExpireDateValidator::CENTURY}" }
    let(:year_in_the_past) { "12/#{Time.now.year - ValidExpireDateValidator::CENTURY - 1}" }

    it { is_expected.to allow_value(valid_date).for(:expire_date).with_message(I18n.t('checkout.errors.expire_date')) }
    it { is_expected.not_to allow_value(month_in_the_past).for(:expire_date).with_message(I18n.t('checkout.errors.invalid_expire_date')) }
    it { is_expected.not_to allow_value(year_in_the_past).for(:expire_date).with_message(I18n.t('checkout.errors.invalid_expire_date')) }
  end
end

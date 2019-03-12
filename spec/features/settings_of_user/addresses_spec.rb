require 'rails_helper'

describe 'Addresses of User', type: :feature, js: true do
  let(:user_with_addresses) { create(:user, :with_addresses) }
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:address) }
  let(:input_fields_count) { 6 }

  before do
    login_as(user, scope: :user)
    visit edit_user_registration_path
  end

  it 'current page is addresses of user' do
    expect(page).to have_current_path edit_user_registration_path
    expect(page).to have_selector 'a', text: I18n.t('user_settings.privacy')
    expect(page).to have_selector 'a', text: I18n.t('user_settings.address')
    expect(page).to have_selector 'h1', text: I18n.t('user_settings.settings')
    expect(page).to have_selector 'h3', text: I18n.t('user_settings.billing')
    expect(page).to have_selector 'h3', text: I18n.t('user_settings.shipping')
  end

  context 'when billing' do
    let(:billing) { user_with_addresses.addresses.billing.first }

    it 'billing address in the fields already' do
      login_as(user_with_addresses, scope: :user)
      visit edit_user_registration_path

      expect(page).to have_field 'address_form[first_name]', with: billing.first_name
      expect(page).to have_field 'address_form[last_name]', with: billing.last_name
      expect(page).to have_field 'address_form[city]', with: billing.city
      expect(page).to have_field 'address_form[street]', with: billing.street
      expect(page).to have_field 'address_form[zip]', with: billing.zip
      expect(page).to have_field 'address_form[country]', with: billing.country
      expect(page).to have_field 'address_form[phone]', with: billing.phone
    end

    it 'valid input' do
      first('#address_form_first_name').set valid_attributes[:first_name]
      first('#address_form_last_name').set valid_attributes[:last_name]
      first('#address_form_city').set valid_attributes[:city]
      first('#address_form_street').set valid_attributes[:street]
      first('#address_form_zip').set valid_attributes[:zip]
      first('#address_form_phone').set valid_attributes[:phone]
      first('input[type=submit]').click
      expect(page).to have_selector 'div', text: I18n.t('user_settings.success', kind: billing.kind.capitalize)
    end

    it 'invalid input' do
      first('input[type=submit]').click
      expect(page).to have_selector '.invalid-feedback', text: I18n.t('simple_form.error_notification.blank'),
                                                         count: input_fields_count
    end
  end

  context 'when shipping' do
    let(:shipping) { user_with_addresses.addresses.shipping.first }

    it 'shipping address in the fields already' do
      login_as(user_with_addresses, scope: :user)
      visit edit_user_registration_path

      expect(page).to have_field 'address_form[first_name]', with: shipping.first_name
      expect(page).to have_field 'address_form[last_name]', with: shipping.last_name
      expect(page).to have_field 'address_form[city]', with: shipping.city
      expect(page).to have_field 'address_form[street]', with: shipping.street
      expect(page).to have_field 'address_form[zip]', with: shipping.zip
      expect(page).to have_field 'address_form[country]', with: shipping.country
      expect(page).to have_field 'address_form[phone]', with: shipping.phone
    end

    it 'valid input' do
      all('#address_form_first_name').last.set valid_attributes[:first_name]
      all('#address_form_last_name').last.set valid_attributes[:last_name]
      all('#address_form_city').last.set valid_attributes[:city]
      all('#address_form_street').last.set valid_attributes[:street]
      all('#address_form_zip').last.set valid_attributes[:zip]
      all('#address_form_phone').last.set valid_attributes[:phone]
      all('input[type=submit]').last.click
      expect(page).to have_selector 'div', text: I18n.t('user_settings.success', kind: shipping.kind.capitalize)
    end

    it 'invalid input' do
      all('input[type=submit]').last.click
      expect(page).to have_selector '.invalid-feedback', text: I18n.t('simple_form.error_notification.blank'),
                                                         count: input_fields_count
    end
  end
end

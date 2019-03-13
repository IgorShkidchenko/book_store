require 'rails_helper'

describe 'Address', type: :feature, js: true do
  let(:order) { create(:order_in_checkout_form_steps) }
  let(:user) { order.user }

  describe 'when positive scenario' do
    let(:valid_attributes) { attributes_for(:address) }
    let(:billing) { user_with_addresses.addresses.billing.first }
    let(:shipping) { user_with_addresses.addresses.shipping.first }
    let(:user_with_addresses) { create(:user, :with_addresses) }
    let(:order_for_user_with_addresses) { create(:order_in_checkout_form_steps, user: user_with_addresses) }

    before do
      login_as(user, scope: :user)
      page.set_rack_session(order_id: order.id)
      visit checkout_step_path(CheckoutStepsController::STEPS[:address])
    end

    it 'current page is address' do
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:address])
      expect(page).to have_selector 'h3', text: I18n.t('checkout.address_page.billing')
      expect(page).to have_selector 'h3', text: I18n.t('checkout.address_page.shipping')
    end

    it 'when order data on page' do
      expect(page).to have_selector 'p', text: order.decorate.subtotal_price
      expect(page).to have_selector '.font-17', text: order.decorate.total_price
    end

    it 'addresses data of user in the fields already' do
      login_as(user_with_addresses, scope: :user)
      page.set_rack_session(order_id: order_for_user_with_addresses.id)
      visit checkout_step_path(CheckoutStepsController::STEPS[:address])

      expect(page).to have_field 'order[billing][first_name]', with: billing.first_name
      expect(page).to have_field 'order[billing][last_name]', with: billing.last_name
      expect(page).to have_field 'order[billing][city]', with: billing.city
      expect(page).to have_field 'order[billing][street]', with: billing.street
      expect(page).to have_field 'order[billing][zip]', with: billing.zip
      expect(page).to have_field 'order[billing][country]', with: billing.country
      expect(page).to have_field 'order[billing][phone]', with: billing.phone
      expect(page).to have_field 'order[shipping][first_name]', with: shipping.first_name
      expect(page).to have_field 'order[shipping][last_name]', with: shipping.last_name
      expect(page).to have_field 'order[shipping][city]', with: shipping.city
      expect(page).to have_field 'order[shipping][street]', with: shipping.street
      expect(page).to have_field 'order[shipping][zip]', with: shipping.zip
      expect(page).to have_field 'order[shipping][country]', with: shipping.country
      expect(page).to have_field 'order[shipping][phone]', with: shipping.phone
    end

    it 'valid input' do
      fill_in 'order[billing][first_name]', with: valid_attributes[:first_name]
      fill_in 'order[billing][last_name]', with: valid_attributes[:last_name]
      fill_in 'order[billing][city]', with: valid_attributes[:city]
      fill_in 'order[billing][street]', with: valid_attributes[:street]
      fill_in 'order[billing][zip]', with: valid_attributes[:zip]
      fill_in 'order[billing][phone]', with: valid_attributes[:phone]
      fill_in 'order[shipping][first_name]', with: valid_attributes[:first_name]
      fill_in 'order[shipping][last_name]', with: valid_attributes[:last_name]
      fill_in 'order[shipping][city]', with: valid_attributes[:city].succ
      fill_in 'order[shipping][street]', with: valid_attributes[:street]
      fill_in 'order[shipping][zip]', with: valid_attributes[:zip]
      fill_in 'order[shipping][phone]', with: valid_attributes[:phone]
      click_on I18n.t('checkout.buttons.next')
      expect(order.addresses.billing.first.city).to eq valid_attributes[:city]
      expect(order.addresses.shipping.first.city).to eq valid_attributes[:city].succ
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:delivery])
    end

    it 'use billing address checkbox' do
      expect(page).to have_selector '#shipping-form'
      fill_in 'order[billing][first_name]', with: valid_attributes[:first_name]
      fill_in 'order[billing][last_name]', with: valid_attributes[:last_name]
      fill_in 'order[billing][city]', with: valid_attributes[:city]
      fill_in 'order[billing][street]', with: valid_attributes[:street]
      fill_in 'order[billing][zip]', with: valid_attributes[:zip]
      fill_in 'order[billing][phone]', with: valid_attributes[:phone]
      first('.fa-check').click
      sleep(3)
      expect(page).not_to have_selector '#shipping-form'
      click_on I18n.t('checkout.buttons.next')
      expect(order.addresses.billing.first.city).to eq valid_attributes[:city]
      expect(order.addresses.shipping.first.city).to eq order.addresses.billing.first.city
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:delivery])
    end
  end

  describe 'when negative scenario' do
    let(:input_fields_count) { 12 }

    before do
      login_as(user, scope: :user)
      page.set_rack_session(order_id: order.id)
      visit checkout_step_path(CheckoutStepsController::STEPS[:address])
    end

    it 'invalid input' do
      click_on I18n.t('checkout.buttons.next')
      expect(page).to have_selector '.invalid-feedback', text: I18n.t('simple_form.error_notification.blank'),
                                                         count: input_fields_count
    end

    it 'can not go to disallowed step' do
      CheckoutStepsController::STEPS.except(:address).values.each do |step|
        visit checkout_step_path(step)
        expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:address])
        expect(page).to have_selector 'div', text: I18n.t('checkout.follow_steps')
      end
    end
  end
end

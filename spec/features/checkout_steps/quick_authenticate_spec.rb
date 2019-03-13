require 'rails_helper'

describe 'Quick authenticate', type: :feature, js: true do
  let(:order) { create(:order, :with_order_items) }
  let(:user) { create(:user) }

  describe 'when positive scenario' do
    let(:valid_attributes) { attributes_for(:user) }

    before do
      page.set_rack_session(order_id: order.id)
      visit checkout_step_path(CheckoutStepsController::STEPS[:authenticate])
    end

    it 'sign in' do
      first('#user_email').set user.email
      first('#user_password').set user.password
      click_button I18n.t('devise_pages.log_in')
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:address])
    end

    it 'quick sign up' do
      all('#user_email').last.set valid_attributes[:email]
      click_button I18n.t('checkout.quick_sing_in.button_quick')
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:address])
    end
  end

  describe 'when negative scenario' do
    it 'when cart is empty redirect to catalog' do
      login_as(user, scope: :user)
      visit checkout_step_path(CheckoutStepsController::STEPS[:authenticate])
      expect(page).to have_current_path books_path
    end

    it 'when redirect to authenticate step if user not logged in' do
      page.set_rack_session(order_id: order.id)
      CheckoutStepsController::STEPS.except(:authenticate).values.each do |step|
        visit checkout_step_path(step)
        expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:authenticate])
      end
    end

    context 'when invalid data' do
      let(:invalid_input) { '@@' }
      let(:invalid_key) { 'Email' }

      before do
        page.set_rack_session(order_id: order.id)
        visit checkout_step_path(CheckoutStepsController::STEPS[:authenticate])
      end

      it 'sign in' do
        first('#user_email').set invalid_input
        first('#user_password').set user.password
        click_button I18n.t('devise_pages.log_in')
        expect(page).to have_selector 'div', text: I18n.t('devise.failure.not_found_in_database', authentication_keys: invalid_key)
      end

      it 'quick sign up' do
        all('#user_email').last.set invalid_input
        click_button I18n.t('checkout.quick_sing_in.button_quick')
        expect(page).to have_selector 'div', text: I18n.t('devise.errors.email')
      end
    end
  end
end

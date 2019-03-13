require 'rails_helper'

describe 'Payment', type: :feature, js: true do
  let(:order) { create(:order_in_checkout_form_steps, :payment_step) }
  let(:user) { order.user }

  before do
    login_as(user, scope: :user)
    page.set_rack_session(order_id: order.id)
    visit checkout_step_path(CheckoutStepsController::STEPS[:payment])
  end

  describe 'when positive scenario' do
    let(:valid_attributes) { attributes_for(:credit_card) }

    it 'current page is payment' do
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:payment])
      expect(page).to have_selector 'h3', text: I18n.t('checkout.payment_page.credit_card')
    end

    it 'cvv hint' do
      first('.fa-question-circle').click
      sleep(3)
      expect(page).to have_selector 'p', text: I18n.t('checkout.payment_page.form.cvv_hint')
    end

    it 'valid input' do
      fill_in 'order[credit_card][number]', with: valid_attributes[:number]
      fill_in 'order[credit_card][name]', with: valid_attributes[:name]
      fill_in 'order[credit_card][expire_date]', with: valid_attributes[:expire_date]
      fill_in 'order[credit_card][cvv]', with: valid_attributes[:cvv]

      click_on I18n.t('checkout.buttons.next')
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:edit])
      expect(order.credit_card.number).to eq valid_attributes[:number]
    end
  end

  describe 'when negative scenario' do
    let(:input_fields_count) { 4 }

    it 'invalid input' do
      click_on I18n.t('checkout.buttons.next')
      expect(page).to have_selector '.invalid-feedback', text: I18n.t('simple_form.error_notification.blank'),
                                                         count: input_fields_count
    end

    it 'can not go to disallowed step' do
      CheckoutStepsController::STEPS.except(:payment).values.each do |step|
        visit checkout_step_path(step)
        expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:payment])
        expect(page).to have_selector 'div', text: I18n.t('checkout.follow_steps')
      end
    end
  end
end

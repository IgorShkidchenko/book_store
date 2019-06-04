require 'rails_helper'

describe 'Delivery', type: :feature, js: true do
  let(:order) { create(:order_in_checkout_form_steps, :delivery_step) }
  let(:user) { order.user }
  let!(:delivery_methods) { create_list(:delivery_method, 3) }
  let(:delivery_method) { delivery_methods.first }

  before do
    login_as(user, scope: :user)
    page.set_rack_session(order_id: order.id)
    visit checkout_step_path(CheckoutStepsController::STEPS[:delivery])
  end

  describe 'when positive scenario' do
    it 'current page is delivery' do
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:delivery])
      expect(page).to have_selector 'h3', text: I18n.t('checkout.delivery')
    end

    it 'when delivery method data on page' do
      expect(page).to have_selector 'span', text: delivery_method.name
      expect(page).to have_selector 'span', text: delivery_method.decorate.delivery_days
      expect(page).to have_selector 'span', text: I18n.t('price', price: delivery_method.cost)
    end

    it 'choose delivery method' do
      first('.radio-icon').click
      click_on I18n.t('checkout.buttons.next')
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:payment])
      expect(page).to have_selector 'p', text: I18n.t('price', price: delivery_method.cost)
    end
  end

  describe 'when negative scenario' do
    it 'can not go to disallowed step' do
      CheckoutStepsController::STEPS.except(:delivery).values.each do |step|
        visit checkout_step_path(step)
        expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:delivery])
        expect(page).to have_selector 'div', text: I18n.t('checkout.follow_steps')
      end
    end
  end
end

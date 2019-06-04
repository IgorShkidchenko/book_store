require 'rails_helper'

describe 'Confirm', type: :feature, js: true do
  let!(:order) { create(:order_in_checkout_final_steps, :confirm_step).decorate }
  let(:user) { order.user }
  let(:order_item) { order.order_items.last.decorate }
  let(:book) { order.books.first }
  let(:billing) { order.addresses.billing.first.decorate }
  let(:shipping) { order.addresses.shipping.first.decorate }
  let(:credit_card) { order.credit_card.decorate }
  let(:edit_link_count) { 4 }

  before do
    login_as(user, scope: :user)
    page.set_rack_session(order_id: order.id)
    visit checkout_step_path(CheckoutStepsController::STEPS[:edit])
  end

  it 'current page is confrim' do
    expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:edit])
    expect(page).to have_selector 'h3', text: I18n.t('checkout.address_page.billing')
    expect(page).to have_selector 'h3', text: I18n.t('checkout.address_page.shipping')
    expect(page).to have_selector 'h3', text: I18n.t('checkout.confirm_page.shipments')
    expect(page).to have_selector 'h3', text: I18n.t('checkout.confirm_page.payment_info')
  end

  it 'when billing address data on page' do
    expect(page).to have_selector 'p', text: billing.full_name
    expect(page).to have_selector 'p', text: billing.street
    expect(page).to have_selector 'p', text: billing.city_with_zip
    expect(page).to have_selector 'p', text: billing.country
    expect(page).to have_selector 'p', text: I18n.t('checkout.address_phone', number: billing.phone)
  end

  it 'when shipping address data on page' do
    expect(page).to have_selector 'p', text: shipping.full_name
    expect(page).to have_selector 'p', text: shipping.street
    expect(page).to have_selector 'p', text: shipping.city_with_zip
    expect(page).to have_selector 'p', text: shipping.country
    expect(page).to have_selector 'p', text: I18n.t('checkout.address_phone', number: shipping.phone)
  end

  it 'when credit_card data on page' do
    expect(page).to have_selector 'p', text: credit_card.masked_number
    expect(page).to have_selector 'p', text: credit_card.expire_date
  end

  it 'when delivery_method data on page' do
    expect(page).to have_selector 'p', text: order.delivery_method_name
  end

  it 'when book data on page' do
    expect(page).to have_selector 'p', text: book.title
    expect(page).to have_selector 'span', text: I18n.t('price', price: book.price)
    expect(page).to have_selector '.general-thumbnail-img'
  end

  it 'when order_item data on page' do
    expect(page).to have_selector 'span', text: order_item.total_price
    expect(first('.quantity-input').value).to eq order_item.quantity.to_s
  end

  it 'when order summary data on page' do
    expect(page).to have_selector 'p', text: order.subtotal_price
    expect(page).to have_selector '.font-17', text: order.total_price
    expect(page).to have_selector 'p', text: I18n.t('price', price: order.delivery_method.cost)
  end

  it 'when plus/minus quantity, destroy, edit checkout links is showed' do
    expect(page).to have_selector '.fa-minus'
    expect(page).to have_selector '.fa-plus'
    expect(page).to have_selector '.general-cart-close'
    expect(page).to have_selector 'a', text: I18n.t('checkout.confirm_page.edit_link'), count: edit_link_count
  end

  describe 'when edit navigation' do
    it 'when address, order data already in the fields and after update redirect to confrim step' do
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
      click_on I18n.t('checkout.buttons.next')
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:edit])
    end

    it 'when shipping was cloned Use Billing checkbox is checked' do
      visit checkout_step_path(CheckoutStepsController::STEPS[:address])
      first('.fa-check').click
      sleep(3)
      click_on I18n.t('checkout.buttons.next')
      visit checkout_step_path(CheckoutStepsController::STEPS[:address])
      expect(page).not_to have_selector '#shipping-form'
    end

    it 'when delivery method, order data already in the fields and after update redirect to confrim step' do
      visit checkout_step_path(CheckoutStepsController::STEPS[:delivery])
      order_delivivery_radio_button = all("#order_delivery_method_id_#{order.delivery_method.id}", visible: false).last
      expect(order_delivivery_radio_button.checked?).to eq true
      click_on I18n.t('checkout.buttons.next')
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:edit])
    end

    it 'when credit card, order data already in the fields' do
      visit checkout_step_path(CheckoutStepsController::STEPS[:payment])
      expect(page).to have_field 'order[credit_card][number]', with: credit_card.number
      expect(page).to have_field 'order[credit_card][name]', with: credit_card.name
      expect(page).to have_field 'order[credit_card][expire_date]', with: credit_card.expire_date
    end
  end

  it 'when redirect to complete step' do
    click_on I18n.t('checkout.buttons.place_order')
    sleep(3)
    expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:complete])
  end

  describe 'when negative scenario' do
    it 'when can not go to disallowed step' do
      visit checkout_step_path(CheckoutStepsController::STEPS[:authenticate])
      expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:edit])
    end
  end
end

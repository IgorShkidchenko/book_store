require 'rails_helper'

describe 'Complete', type: :feature, js: true do
  let(:order) { create(:order_in_checkout_final_steps, :confirm_step).decorate }
  let(:user) { order.user }
  let(:order_item) { order.order_items.last.decorate }
  let(:book) { order.books.first }
  let(:billing) { order.addresses.billing.first.decorate }

  before do
    login_as(user, scope: :user)
    page.set_rack_session(order_id: order.id)
    visit checkout_step_path(CheckoutStepsController::STEPS[:edit])
    click_on I18n.t('checkout.buttons.place_order')
    sleep(2)
  end

  it 'current page is complete' do
    expect(page).to have_current_path checkout_step_path(CheckoutStepsController::STEPS[:complete])
    expect(page).to have_selector 'h3', text: I18n.t('checkout.complete_page.thank_you')
    expect(page).to have_selector 'p', text: I18n.t('checkout.complete_page.msg_was_sent', email: user.email)
  end

  it 'when billing address data on page' do
    expect(page).to have_selector 'p', text: billing.full_name
    expect(page).to have_selector 'p', text: billing.street
    expect(page).to have_selector 'p', text: billing.city_with_zip
    expect(page).to have_selector 'p', text: billing.country
    expect(page).to have_selector 'p', text: I18n.t('checkout.address_phone', number: billing.phone)
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

  it 'when order data on page' do
    expect(page).to have_selector 'p', text: I18n.t('price', price: order.delivery_method.cost)
    expect(page).to have_selector 'p', text: order.subtotal_price
    expect(page).to have_selector 'p', text: order.creation_date
    expect(page).to have_selector '.font-17', text: order.total_price
  end

  it 'when plus/minus quantity, destroy, edit checkout links do not show' do
    expect(page).not_to have_selector '.fa-minus'
    expect(page).not_to have_selector '.fa-plus'
    expect(page).not_to have_selector '.general-cart-close'
    expect(page).not_to have_selector 'a', text: I18n.t('checkout.confirm_page.edit_link')
  end
end

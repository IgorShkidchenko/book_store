require 'rails_helper'

describe 'Orders show', type: :feature, js: true do
  let(:order) { create(:order, :completed_with_user).decorate }
  let(:order_item) { order.order_items.last.decorate }
  let(:book) { order.books.first }
  let(:user) { order.user }
  let(:billing) { order.addresses.billing.first.decorate }
  let(:shipping) { order.addresses.shipping.first.decorate }
  let(:credit_card) { order.credit_card.decorate }

  before do
    login_as(user, scope: :user)
    visit order_path(order)
  end

  it 'current page is orders of user' do
    expect(page).to have_current_path order_path(order)
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

  it 'when order data on page' do
    expect(page).to have_selector 'a', text: I18n.t('orders.order_number', number: order.number)
    expect(page).to have_selector 'p', text: order.subtotal_price
    expect(page).to have_selector '.font-17', text: order.total_price
  end

  it 'when plus/minus quantity, destroy, edit checkout links do not show' do
    expect(page).not_to have_content '.fa-minus'
    expect(page).not_to have_content '.fa-plus'
    expect(page).not_to have_content '.general-cart-close'
    expect(page).not_to have_selector 'a', text: I18n.t('checkout.address_page.edit_link')
  end
end

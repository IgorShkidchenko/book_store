require 'rails_helper'

describe 'Orders index', type: :feature, js: true do
  let(:order) { create(:order_in_checkout_final_steps, :delivered).decorate }
  let(:user) { order.user }

  before do
    login_as(user, scope: :user)
    visit user_orders_path(user)
  end

  it 'current page is orders index' do
    expect(page).to have_current_path user_orders_path(user)
  end

  it 'when order data on page' do
    expect(page).to have_selector 'a', text: order.number
    expect(page).to have_selector 'span', text: order.creation_date
    expect(page).to have_selector 'span', text: order.creation_date
    expect(page).to have_selector 'p', text: order.total_price
  end

  it 'when redirect to order page' do
    click_on order.number
    sleep(5)
    expect(page).to have_current_path order_path(order)
  end
end

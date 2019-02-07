require 'rails_helper'

describe 'Cart page', type: :feature, js: true do
  let(:order) { FactoryBot.create(:order, :with_order_items) }
  let(:order_item) { order.order_items.last }
  let(:book) { order.books.first }
  let(:user) { FactoryBot.create(:user) }

  before do
    page.set_rack_session(order_id: order.id)
    visit root_path
    first('.shop-link').click
  end

  it 'current page is cart' do
    page.driver.browser.navigate.refresh
    expect(page).to have_current_path order_path(order)
  end

  context 'when book data on page' do
    it { expect(page).to have_selector 'p', text: book.title }
    it { expect(page).to have_selector 'span', text: I18n.t('price', price: book.price) }
    it { expect(page).to have_selector '.general-thumbnail-img' }
  end

  context 'when order_item data on page' do
    it { expect(page).to have_selector 'span', text: I18n.t('price', price: order_item.total_price) }
    it { expect(first('.quantity-input').value).to eq order_item.quantity.to_s }
  end

  context 'when order data on page' do
    it { expect(page).to have_selector 'p', text: I18n.t('price', price: order.subtotal_price) }
    it { expect(page).to have_selector '.font-17', text: I18n.t('price', price: order.total_price) }
  end

  describe 'when change order_item quantity' do
    context 'when plus quantity' do
      let!(:updated_order_price) { (book.price * order_item.quantity) + book.price }
      let!(:incrased_quantity) { (order_item.quantity + 1).to_s }

      before do
        sleep(1)
        first('.fa-plus').click
        wait_for_ajax
      end

      it { expect(first('.quantity-input').value).to eq incrased_quantity }
      it { expect(updated_order_price).to eq order.reload.total_price.round(2) }
      it { expect(page).to have_selector '.shop-quantity', text: incrased_quantity }
    end

    context 'when minus quantity' do
      let!(:decrased_quantity) { (order_item.quantity - 1).to_s }
      let!(:updated_order_price) { (book.price * order_item.quantity) - book.price }

      before do
        sleep(1)
        first('.fa-minus').click
        wait_for_ajax
      end

      it { expect(first('.quantity-input').value).to eq decrased_quantity }
      it { expect(updated_order_price).to eq order.reload.total_price.round(2) }
      it { expect(page).to have_selector '.shop-quantity', text: decrased_quantity }
    end
  end

  context 'with valid coupon' do
    let(:coupon) { FactoryBot.create(:coupon) }
    let!(:updated_order_price) { order_item.total_price - coupon.discount }

    before do
      fill_in 'coupon[key]', with: coupon.key
      click_on I18n.t('cart.page.apply_coupon')
      wait_for_ajax
    end

    it { expect(page).to have_selector 'p', text: coupon.discount.to_s }
    it { expect(page).to have_selector 'p', text: I18n.t('coupon.was_used') }
    it { expect(updated_order_price).to eq order.reload.total_price }
  end

  context 'with invalid coupon' do
    let(:coupon) { FactoryBot.create(:coupon, order_id: order.id) }

    it 'coupon was used' do
      fill_in 'coupon[key]', with: coupon.key
      click_on I18n.t('cart.page.apply_coupon')
      wait_for_ajax
      expect(page).to have_content I18n.t('coupon.error_used')
    end

    it 'coupon was does not exist' do
      fill_in 'coupon[key]', with: coupon.key.succ
      click_on I18n.t('cart.page.apply_coupon')
      wait_for_ajax
      expect(page).to have_content I18n.t('coupon.error_havent')
    end
  end

  context 'when destroy order_item' do
    it do
      first('.general-cart-close').click
      wait_for_ajax
      expect(page).to have_content I18n.t('cart.page.empty_cart')
    end
  end
end

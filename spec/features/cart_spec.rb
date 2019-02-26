require 'rails_helper'

describe 'Cart page', type: :feature, js: true do
  let(:order) { FactoryBot.create(:order, :with_order_items).decorate }
  let(:order_item) { order.order_items.last.decorate }
  let(:book) { order.books.first }
  let(:user) { FactoryBot.create(:user) }

  before do
    allow(BestSellersQuery).to receive(:call).and_return([book])
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
    it { expect(page).to have_selector 'span', text: order_item.total_price }
    it { expect(first('.quantity-input').value).to eq order_item.quantity.to_s }
  end

  context 'when order data on page' do
    it { expect(page).to have_selector 'p', text: order.subtotal_price }
    it { expect(page).to have_selector '.font-17', text: order.total_price }
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
      it { expect(page).to have_selector '.font-17', text: updated_order_price }
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
      it { expect(page).to have_selector '.font-17', text: updated_order_price }
      it { expect(page).to have_selector '.shop-quantity', text: decrased_quantity }
    end
  end

  context 'with valid coupon' do
    let(:coupon) { FactoryBot.create(:coupon) }

    before do
      fill_in 'coupon[key]', with: coupon.key
      click_on I18n.t('cart.page.apply_coupon')
      wait_for_ajax
    end

    it { expect(page).to have_selector 'p', text: coupon.discount.to_s }
    it { expect(page).to have_selector 'p', text: I18n.t('coupon.was_used') }
  end

  context 'with invalid coupon' do
    let!(:used_coupon) { FactoryBot.create(:coupon, :used) }

    context 'when was used' do
      it do
        fill_in 'coupon[key]', with: used_coupon.key
        click_on I18n.t('cart.page.apply_coupon')
        wait_for_ajax
        expect(page).to have_content I18n.t('coupon.error_used')
      end
    end

    context 'when does not exist' do
      it do
        fill_in 'coupon[key]', with: used_coupon.key.succ
        click_on I18n.t('cart.page.apply_coupon')
        wait_for_ajax
        expect(page).to have_content I18n.t('coupon.error_havent')
      end
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

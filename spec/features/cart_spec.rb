require 'rails_helper'

describe 'Cart page', type: :feature, js: true do
  let(:order) { create(:order, :with_order_items).decorate }
  let(:order_item) { order.order_items.last.decorate }
  let(:book) { order.books.first }
  let(:user) { create(:user) }

  before do
    page.set_rack_session(order_id: order.id)
    visit order_order_items_path(order.id)
  end

  it 'current page is cart' do
    allow(Books::BestSellersQuery).to receive(:call).and_return([book])
    visit root_path
    first('.shop-link').click
    sleep(5)
    expect(page).to have_current_path order_order_items_path(order.id)
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
    expect(page).to have_selector 'p', text: order.subtotal_price
    expect(page).to have_selector '.font-17', text: order.total_price
  end

  describe 'when change order_item quantity' do
    context 'when plus quantity' do
      let!(:updated_order_price) { ((book.price * order_item.quantity) + book.price).round(2) }
      let!(:incrased_quantity) { (order_item.quantity + 1).to_s }

      it do
        first('.fa-plus').click
        wait_for_ajax
        expect(first('.quantity-input').value).to eq incrased_quantity
        expect(page).to have_selector '.font-17', text: updated_order_price
        expect(page).to have_selector '.shop-quantity', text: incrased_quantity
      end
    end

    context 'when minus quantity' do
      let!(:decrased_quantity) { (order_item.quantity - 1).to_s }
      let!(:updated_order_price) { ((book.price * order_item.quantity) - book.price).round(2) }

      it do
        first('.fa-minus').click
        wait_for_ajax
        expect(first('.quantity-input').value).to eq decrased_quantity
        expect(page).to have_selector '.font-17', text: updated_order_price
        expect(page).to have_selector '.shop-quantity', text: decrased_quantity
      end
    end
  end

  context 'with valid coupon' do
    let(:coupon) { create(:coupon) }

    it do
      fill_in 'coupon[key]', with: coupon.key
      click_on I18n.t('cart.page.apply_coupon')
      wait_for_ajax
      expect(page).to have_selector 'p', text: coupon.discount.to_s
      expect(page).to have_selector 'p', text: I18n.t('coupon.was_used')
    end
  end

  context 'with invalid coupon' do
    let!(:used_coupon) { create(:coupon, :used) }

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

require 'rails_helper'

describe 'Root page', type: :feature, js: true do
  let!(:category) { create(:category, :with_book) }
  let(:book) { category.books.last }

  before do
    allow(Books::BestSellersQuery).to receive(:call).and_return([book])
    visit root_path
  end

  it 'current page is home' do
    expect(page).to have_current_path root_path
    expect(page).to have_selector '#slider'
    expect(page).to have_selector 'a', text: I18n.t('layout.link.shop')
    expect(page).to have_selector '.cart_part'
    expect(page).to have_selector 'h1', text: book.title
    expect(page).to have_selector '.title', text: book.title
  end

  it 'redirect to book page' do
    first('.thumbnail').hover
    first('.thumb-hover-link').click
    sleep(5)
    expect(page).to have_current_path book_path(book)
  end

  it 'redirect to catalog page' do
    first('.dropdown-toggle').click
    click_link category.name
    expect(page).to have_current_path category_books_path(category_id: book.category_id)
  end

  it 'when book data on page' do
    expect(page).to have_selector 'p', text: book.title
    expect(page).to have_selector 'p', text: book.decorate.authors_as_string
    expect(page).to have_selector 'p', text: I18n.t('price', price: book.price)
    expect(page).to have_selector '.general-thumbnail-img'
  end

  it 'when user not logged in' do
    expect(page).not_to have_selector 'a', text: I18n.t('layout.link.log_out')
    expect(page).not_to have_selector 'a', text: I18n.t('layout.header.my_account')
    expect(page).to have_selector 'a', text: I18n.t('layout.link.sign_up')
    expect(page).to have_selector 'a', text: I18n.t('layout.link.log_in')
  end

  context 'when user logged in' do
    let(:user) { create(:user) }

    before do
      login_as(user, scope: :user)
      page.driver.browser.navigate.refresh
    end

    it 'header links' do
      click_on I18n.t('layout.header.my_account')
      expect(page).to have_selector 'a', text: I18n.t('layout.link.log_out')
      expect(page).not_to have_selector 'a', text: I18n.t('layout.link.sign_up')
      expect(page).not_to have_selector 'a', text: I18n.t('layout.link.log_in')
    end

    it 'redirect to orders of user' do
      click_on I18n.t('layout.link.orders')
      expect(page).to have_current_path user_orders_path(user)
    end

    it 'redirect to settings of user' do
      click_on I18n.t('layout.link.settings')
      expect(page).to have_current_path edit_user_registration_path
    end
  end

  context 'when add to cart' do
    let!(:order) { create(:order) }
    let(:book_count_in_cart) { order.order_items.size }

    before do
      page.set_rack_session(order_id: order.id)
      visit root_path
    end

    it 'from book on slider' do
      click_on I18n.t('home.buy_button')
      expect(page).to have_selector '.shop-quantity', text: book_count_in_cart
    end

    it 'from book partial' do
      first('.thumbnail').hover
      sleep(1)
      all('.thumb-hover-link').last.click
      expect(page).to have_selector '.shop-quantity', text: book_count_in_cart
    end

    it 'current book in the cart' do
      click_on I18n.t('home.buy_button')
      first('.shop-link').click
      sleep(5)
      expect(page).to have_selector 'p', text: book.title
    end
  end
end

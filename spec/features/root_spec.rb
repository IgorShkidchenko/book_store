require 'rails_helper'

describe 'Root page', type: :feature, js: true do
  let!(:category) { FactoryBot.create(:category, :with_book) }
  let(:book) { category.books.last }

  before do
    allow(Books::BestSellersQuery).to receive(:call).and_return([book])
    visit root_path
  end

  it 'current page is home' do
    expect(page).to have_current_path root_path
  end

  it 'slider present' do
    expect(page).to have_selector '#slider'
  end

  it 'footer present' do
    expect(page).to have_selector 'a', text: I18n.t('layout.link.shop')
  end

  it 'header present' do
    expect(page).to have_selector '.cart_part'
  end

  it 'books showed on slider' do
    expect(page).to have_selector 'h1', text: book.title
  end

  it 'books on bestseller row' do
    expect(page).to have_selector '.title', text: book.title
  end

  it 'redirect to book page' do
    first('.thumbnail').hover
    first('.thumb-hover-link').click
    page.driver.browser.navigate.refresh
    expect(page).to have_current_path book_path(book)
  end

  it 'redirect to catalog page' do
    first('.dropdown-toggle').click
    click_link category.name
    expect(page).to have_current_path category_books_path(category_id: book.category_id)
  end

  context 'when book data on page' do
    it { expect(page).to have_selector 'p', text: book.title }
    it { expect(page).to have_selector 'p', text: book.decorate.authors_as_string }
    it { expect(page).to have_selector 'p', text: I18n.t('price', price: book.price) }
    it { expect(page).to have_selector '.general-thumbnail-img' }
  end

  context 'when user not logged in' do
    it { expect(page).not_to have_selector 'a', text: I18n.t('layout.link.log_out') }
    it { expect(page).to have_selector 'a', text: I18n.t('layout.link.sign_up') }
    it { expect(page).to have_selector 'a', text: I18n.t('layout.link.log_in') }
  end

  context 'when user logged in' do
    before do
      login_as(FactoryBot.create(:user), scope: :user)
      page.driver.browser.navigate.refresh
      click_on I18n.t('layout.header.my_account')
    end

    it { expect(page).to have_selector 'a', text: I18n.t('layout.link.log_out') }
    it { expect(page).not_to have_selector 'a', text: I18n.t('layout.link.sign_up') }
    it { expect(page).not_to have_selector 'a', text: I18n.t('layout.link.log_in') }
  end

  context 'when add to cart' do
    let!(:order) { FactoryBot.create(:order) }
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
      page.driver.browser.navigate.refresh
      expect(page).to have_selector 'p', text: book.title
    end
  end
end

require 'rails_helper'

describe 'Books page', type: :feature, js: true do
  let!(:book) { create(:book, :with_author).decorate }

  before { visit book_path(book) }

  it 'current page is book' do
    expect(page).to have_current_path book_path(book)
  end

  it 'when book data on page' do
    expect(page).to have_selector 'h1', text: book.title
    expect(page).to have_selector 'p', text: book.published_year
    expect(page).to have_selector 'p', text: book.materials
    expect(page).to have_selector 'p', text: book.authors_as_string
    expect(page).to have_selector 'p', text: book.dimensions
    expect(page).to have_selector 'p', text: book.medium_description
    expect(page).to have_selector 'p', text: I18n.t('price', price: book.price)
    expect(page).to have_selector '.general-thumbnail-img'
  end

  context 'when readmore button' do
    it { expect(page).not_to have_selector 'p', text: book.the_rest_of_description }

    it 'show full description after click readmore button' do
      first('#read-more-btn').click
      expect(page).to have_selector 'p', text: book.the_rest_of_description
    end
  end

  context 'when back button' do
    before do
      allow(Books::BestSellersQuery).to receive(:call).and_return([book])
      first('.navbar-brand').click
      first('.thumbnail').hover
      first('.thumb-hover-link').click
    end

    it 'click back button after refreh' do
      page.driver.browser.navigate.refresh
      first('.general-back-link').click
      expect(page).to have_current_path root_path
    end
  end

  context 'when add to cart' do
    let(:order) { create(:order) }
    let(:book_count_in_cart) { order.order_items.size }

    before do
      page.set_rack_session(order_id: order.id)
      visit book_path(book)
    end

    it do
      click_on I18n.t('book.page.add_to_cart')
      expect(page).to have_selector '.shop-quantity', text: book_count_in_cart
    end
  end
end

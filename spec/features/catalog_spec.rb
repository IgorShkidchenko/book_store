require 'rails_helper'

describe 'Catalog page', type: :feature, js: true do
  let!(:category) { create(:category, :with_books) }
  let(:category_book) { category.books.second }
  let(:book) { create(:book) }
  let(:pagy_button_name) { 'Next' }
  let(:books_on_page_quantity) { 12 }

  before { visit category_books_path(category_id: category.id) }

  it 'current page is catalog' do
    expect(page).to have_current_path category_books_path(category_id: category.id)
    expect(page).to have_selector '.title', count: books_on_page_quantity
    expect(page).to have_selector 'a', text: pagy_button_name, count: 1
    expect(page).to have_selector 'a', text: category.name, count: Category.count
    expect(page).to have_selector '.badge', text: category.books.size
    expect(page).to have_selector 'a', text: I18n.t('catalog.all'), count: 1
    expect(page).to have_selector '.badge', text: Book.count
  end

  it 'filters' do
    first('.lead').click
    Books::FilterQuery::VALID_FILTERS.keys do |filter|
      expect(page).to have_content I18n.t("catalog.dropdown.#{filter}")
    end
  end

  it 'redirect to book page' do
    first('.thumbnail').hover
    first('.thumb-hover-link').click
    expect(page).to have_selector '#read-more-btn'
  end

  it 'when book data on page' do
    expect(page).to have_selector 'p', text: category_book.title
    expect(page).to have_selector 'p', text: category_book.decorate.authors_as_string
    expect(page).to have_selector 'p', text: I18n.t('price', price: category_book.price)
    expect(page).to have_selector '.general-thumbnail-img'
  end
end

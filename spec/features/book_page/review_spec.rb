require 'rails_helper'

describe 'Review', type: :feature, js: true do
  let!(:book) { create(:book, :with_author).decorate }
  let!(:reviews) { create_list(:review, 3, book_id: book.id, status: Review.statuses[:approved]) }

  before { visit book_path(book) }

  it 'all approved reviews count' do
    create(:review, book_id: book.id)
    expect(page).to have_selector 'h3.mb-25', text: Review.approved.size
  end

  context 'when approved review data on page' do
    let(:approved_review) { reviews.first.decorate }
    let(:max_stars_count) { 5 }
    let(:approved_review_empty_stars) { max_stars_count - approved_review.rating }

    it { expect(page).to have_selector 'h4', text: approved_review.title }
    it { expect(page).to have_selector 'p', text: approved_review.body }
    it { expect(first('.mb-15')).to have_selector '.rate-empty', count: approved_review_empty_stars }
    it { expect(page).to have_selector '.general-message-name', text: approved_review.user_email }
    it { expect(page).to have_selector '.general-message-date', text: approved_review.creation_date }
  end

  it 'not logged in user cant see review form' do
    expect(page).not_to have_selector 'h3', text: I18n.t('review.write_review')
  end

  context 'when user logged in' do
    let(:user) { reviews.first.user }
    let(:valid_attribute) { attributes_for :review }
    let(:invalid_input) { '@' }

    before do
      login_as(user, scope: :user)
      page.driver.browser.navigate.refresh
    end

    it { expect(page).to have_selector 'h3', text: I18n.t('review.write_review') }

    it 'fill form with valid data' do
      first('label').click
      fill_in 'review_form[title]', with: valid_attribute[:title]
      fill_in 'review_form[body]', with: valid_attribute[:body]
      click_on I18n.t('review.post')
      expect(page).to have_selector 'div', text: I18n.t('review.success_msg')
    end

    it 'fill form with invalid data' do
      fill_in 'review_form[title]', with: invalid_input
      fill_in 'review_form[body]', with: invalid_input
      click_on I18n.t('review.post')
      expect(page).to have_selector 'div', text: I18n.t('review.validation_format_msg')
    end
  end
end

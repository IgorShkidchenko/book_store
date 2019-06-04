require 'rails_helper'

describe 'Sign in', type: :feature, js: true do
  let(:user) { create(:user) }

  describe 'when sing in/out' do
    before do
      visit root_path
      click_on I18n.t('layout.link.log_in')
    end

    context 'with valid data' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button I18n.t('devise_pages.log_in')
      end

      it 'successful redirect' do
        expect(page).to have_current_path root_path
        expect(page).to have_selector 'div', text: I18n.t('devise.sessions.signed_in')
      end

      it 'sign out' do
        click_on I18n.t('layout.header.my_account')
        click_on I18n.t('layout.link.log_out')
        expect(page).to have_selector 'div', text: I18n.t('devise.sessions.signed_out')
      end
    end

    context 'with invalid data' do
      let(:invalid_email) { user.email.succ }
      let(:invalid_key) { 'Email' }

      it do
        fill_in 'user[email]', with: invalid_email
        fill_in 'user[password]', with: user.password
        click_button I18n.t('devise_pages.log_in')
        expect(page).to have_selector 'div', text: I18n.t('devise.failure.not_found_in_database', authentication_keys: invalid_key)
      end
    end
  end
end

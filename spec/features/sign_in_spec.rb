require 'rails_helper'

describe 'Sign in', type: :feature, js: true do
  let(:user) { FactoryBot.create(:user) }

  describe 'when sing in/out' do
    before do
      visit root_path
      click_on I18n.t('layout.link.log_in')
    end

    context 'with valid data' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        first('.btn-default').click
      end

      it { expect(page).to have_current_path root_path }
      it { expect(page).to have_content I18n.t('devise.sessions.signed_in') }

      it 'sign out' do
        click_on I18n.t('layout.header.my_account')
        click_on I18n.t('layout.link.log_out')
        expect(page).to have_content I18n.t('devise.sessions.signed_out')
      end
    end

    context 'with invalid data' do
      let(:invalid_email) { user.email.succ }
      let(:invalid_key) { 'Email' }

      it do
        fill_in 'user[email]', with: invalid_email
        fill_in 'user[password]', with: user.password
        first('.btn-default').click
        expect(page).to have_content I18n.t('devise.failure.not_found_in_database', authentication_keys: invalid_key)
      end
    end

    it 'Facebook' do
      valid_facebook_login_setup
      first('.fa-facebook-official').click
      expect(page).to have_current_path root_path
    end
  end
end

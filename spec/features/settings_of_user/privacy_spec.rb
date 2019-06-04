require 'rails_helper'

describe 'Privacy', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:new_email) { user.email.succ }
  let(:invalid_email) { '@@' }
  let(:new_password) { user.password.succ }

  before do
    login_as(user, scope: :user)
    visit edit_user_registration_path
    click_on I18n.t('user_settings.privacy')
  end

  it 'current page is privacy of user' do
    expect(page).to have_current_path edit_user_registration_path
    expect(page).to have_selector 'a', text: I18n.t('user_settings.address')
    expect(page).to have_selector 'h1', text: I18n.t('user_settings.settings')
    expect(page).to have_selector 'p', text: I18n.t('user_settings.password')
    expect(page).to have_selector 'p', text: I18n.t('user_settings.email')
    expect(page).to have_selector 'p', text: I18n.t('user_settings.remove')
  end

  context 'when email' do
    it 'user email in the field already' do
      expect(page).to have_field('user[email]', with: user.email)
    end

    it 'valid input' do
      fill_in 'user[email]', with: new_email
      first('.btn.btn-default.mb-35').click
      expect(page).to have_selector 'div', text: I18n.t('devise.registrations.updated')
    end

    it 'invalid input' do
      fill_in 'user[email]', with: invalid_email
      first('.btn.btn-default.mb-35').click
      click_on I18n.t('user_settings.privacy')
      expect(page).to have_selector '.help-block', text: I18n.t('devise.errors.email')
    end
  end

  context 'when password' do
    it 'valid input' do
      fill_in 'user[current_password]', with: user.password
      fill_in 'user[password]', with: new_password
      fill_in 'user[password_confirmation]', with: new_password
      first('.btn.btn-default.mb-10').click
      expect(page).to have_selector 'div', text: I18n.t('devise.registrations.updated')
    end

    it 'invalid input' do
      fill_in 'user[current_password]', with: new_password
      fill_in 'user[password]', with: new_password
      fill_in 'user[password_confirmation]', with: new_password
      first('.btn.btn-default.mb-10').click
      click_on I18n.t('user_settings.privacy')
      expect(page).to have_selector '.help-block', text: I18n.t('devise.errors.password')
    end
  end

  context 'when destroy account' do
    it 'destroying link is disabled' do
      expect(page).to have_link I18n.t('user_settings.please_remove'), class: 'btn-default disabled mb-20'
    end

    it 'activate destroying link and delete account' do
      first('.fa-check').click
      expect(page).not_to have_link I18n.t('user_settings.please_remove'), class: 'btn-default disabled mb-20'
      expect(page).to have_link I18n.t('user_settings.please_remove'), class: 'btn-default mb-20'
      click_on I18n.t('user_settings.please_remove')
      expect(page).to have_selector 'div', text: I18n.t('devise.registrations.destroyed')
    end
  end
end

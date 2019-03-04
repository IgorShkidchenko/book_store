require 'rails_helper'

describe 'Sign up', type: :feature, js: true do
  let(:valid_data) { FactoryBot.attributes_for :user }
  let(:invalid_input) { '@@' }
  let(:error_message) { 'Email is invalid' }

  before do
    visit root_path
    click_on I18n.t('layout.link.sign_up')
  end

  it 'sign up with valid data' do
    fill_in 'user[email]', with: valid_data[:email]
    fill_in 'user[password]', with: valid_data[:password]
    fill_in 'user[password_confirmation]', with: valid_data[:password]
    first('.btn-default').click
    expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')
  end

  it 'sign up with invalid data' do
    fill_in 'user[email]', with: invalid_input
    fill_in 'user[password]', with: valid_data[:password]
    fill_in 'user[password_confirmation]', with: valid_data[:password]
    first('.btn-default').click
    expect(page).to have_selector '.help-block', text: error_message
  end
end

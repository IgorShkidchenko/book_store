require 'rails_helper'

describe 'Facebook', type: :feature, js: true do
  before do
    visit root_path
    click_on I18n.t('layout.link.log_in')
  end

  it 'with valid credentials' do
    valid_facebook_login_setup
    first('.fa-facebook-official').click
    expect(page).to have_current_path root_path
    expect(page).not_to have_selector 'div', text: I18n.t('facebook.error')
    expect(page).not_to have_selector 'div', text: I18n.t('facebook.error_authentication')
  end

  it 'with invalid credentials' do
    invalid_facebook_login_setup
    first('.fa-facebook-official').click
    expect(page).to have_selector 'div', text: I18n.t('facebook.error_authentication')
  end

  it 'when with out credentials' do
    with_out_credentials_facebook_login_setup
    first('.fa-facebook-official').click
    expect(page).to have_selector 'div', text: I18n.t('facebook.error')
  end
end

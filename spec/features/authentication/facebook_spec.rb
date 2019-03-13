require 'rails_helper'

describe 'Facebook', type: :feature, js: true do
  it 'logged in via facebook' do
    visit root_path
    click_on I18n.t('layout.link.log_in')
    valid_facebook_login_setup
    first('.fa-facebook-official').click
    expect(page).to have_current_path root_path
  end
end

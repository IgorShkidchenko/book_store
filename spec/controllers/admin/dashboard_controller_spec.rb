require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when loged in' do
    let(:page) { Capybara::Node::Simple.new(response.body) }

    render_views
    login_admin

    before do
      allow(User).to receive(:all).and_return([])
      allow(Book).to receive(:all).and_return([])
      get :index
    end

    it { expect(subject.current_admin_user).not_to eq nil }
    it { is_expected.to respond_with 200 }
    it { is_expected.to render_template 'index' }
    it { expect(page).to have_content I18n.t('admin.dashboard.users_count', count: User.all.count) }
    it { expect(page).to have_content I18n.t('admin.dashboard.books_count', count: Book.all.count) }
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin').to(action: :index) }
  end
end

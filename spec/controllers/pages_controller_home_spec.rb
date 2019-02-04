require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'when visit home page' do
    before { get :home }

    it { is_expected.to render_template('home') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/').to(action: :home) }
  end
end

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'when visit home page' do
    before { get :index }

    it { is_expected.to render_template('index') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/').to(action: :index) }
  end
end

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'when visit home page' do
    before { get :index }

    it { should render_template('index') }
    it { should respond_with(200) }
    it { should route(:get, '/').to(action: :index) }
  end
end

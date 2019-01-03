require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'when visit index page' do
    before { get :index }

    it { should render_template('index') }
    it { should respond_with(200) }
    it { should route(:get, '/categories/index').to(action: :index) }
  end
end

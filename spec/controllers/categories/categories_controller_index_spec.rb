require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'when visit index page' do
    before { get :index }

    it { is_expected.to render_template('index') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/categories/index').to(action: :index) }
  end
end

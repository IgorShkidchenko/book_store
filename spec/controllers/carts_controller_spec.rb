require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  describe 'when visit show page' do

    before do
      get :show
    end

    it { is_expected.to render_template('show') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/cart').to(action: :show) }
  end
end

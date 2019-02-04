require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:order) { FactoryBot.create(:order) }

  describe 'when visit show page' do
    before do
      get :show, params: { id: order.id }, session: { order_id: order.id }
    end

    it { is_expected.to render_template('show') }
    it { is_expected.to respond_with(200) }
    it { expect(assigns(:order)).to eq order }
    it { is_expected.to route(:get, '/orders/1').to(action: :show, id: 1) }
  end
end

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'when #home' do
    before do
      allow(Books::LatestThreeQuery).to receive(:call)
      allow(Books::BestSellersQuery).to receive(:call)
      get :home
    end

    it { is_expected.to render_template 'home' }
    it { is_expected.to respond_with 200 }
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/').to(action: :home) }
  end
end

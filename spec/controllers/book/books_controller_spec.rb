require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'when visit show page' do
    before { get :show }

    it { is_expected.to render_template('show') }
    it { is_expected.to respond_with(200) }
    it { is_expected.to route(:get, '/books/show').to(action: :show) }
  end
end

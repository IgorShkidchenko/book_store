require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe 'when #create' do
    let(:book) { FactoryBot.create(:book) }
    let(:user) { FactoryBot.create(:user) }
    let(:valid_attributes) { FactoryBot.attributes_for(:review).merge(book_id: book.id, user_id: user.id) }

    before { post :create, params: { review: valid_attributes } }

    it { is_expected.to respond_with(302) }
    it { is_expected.to set_flash[:success].to(I18n.t('review.success_msg')) }
    it { is_expected.to redirect_to(book_path(book.id)) }
  end
end

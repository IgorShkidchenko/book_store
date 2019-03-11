require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe 'when #create' do
    let(:book) { FactoryBot.create(:book) }
    let(:user) { FactoryBot.create(:user) }
    let(:valid_attributes) { FactoryBot.attributes_for(:review).merge(book_id: book.id, user_id: user.id) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      post :create, xhr: true, params: { review_form: valid_attributes }
    end

    it { is_expected.to respond_with(200) }
    it { is_expected.to set_flash[:success].to(I18n.t('review.success_msg')) }
  end
end

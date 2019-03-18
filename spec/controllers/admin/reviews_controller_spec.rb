require 'rails_helper'

RSpec.describe Admin::ReviewsController, type: :controller do
  describe "when isn't admin user, can't open admins pages" do
    it do
      get :index
      expect(subject).to redirect_to(admin_user_session_path)
    end
  end

  describe 'when login' do
    let(:page) { Capybara::Node::Simple.new(response.body) }
    let!(:review) { create(:review) }

    render_views
    login_admin

    describe 'when index' do
      before { get :index }

      it { expect(subject.current_admin_user).not_to eq nil }
      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'index' }
      it { expect(assigns(:reviews)).to include review }
      it { expect(review.unprocessed?).to eq true }
      it { expect(page).to have_content review.book.title }
      it { expect(page).to have_content review.title }
      it { expect(page).to have_content review.body }
      it { expect(page).to have_content I18n.t('admin.column.date') }
      it { expect(page).to have_content review.user.email }
      it { expect(page).to have_content review.status }
      it { expect(page).to have_content I18n.t('admin.actions.show') }
      it { expect(page).to have_content Review.statuses.key(0).to_s.capitalize }
      it { expect(page).to have_content Review.statuses.key(1).to_s.capitalize }
      it { expect(page).to have_content Review.statuses.key(2).to_s.capitalize }
    end

    describe 'when show' do
      before { get :show, params: { id: review.id } }

      it { is_expected.to respond_with 200 }
      it { is_expected.to render_template 'show' }
      it { expect(assigns(:review)).to eq review }
      it { expect(page).to have_content review.book.title }
      it { expect(page).to have_content review.title }
      it { expect(page).to have_content review.body }
      it { expect(page).to have_content review.rating }
      it { expect(page).to have_content review.user.email }
      it { expect(page).to have_content review.status }
      it { expect(page).to have_content Review.statuses.key(1).to_s.capitalize }
      it { expect(page).to have_content Review.statuses.key(2).to_s.capitalize }
    end

    describe 'when approved button from show page' do
      before { put :approved, params: { id: review.id } }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to admin_review_path(review) }

      it do
        review.reload
        expect(review.approved?).to eq true
      end
    end

    describe 'when rejected button from show page' do
      before { put :rejected, params: { id: review.id } }

      it { is_expected.to respond_with 302 }
      it { is_expected.to redirect_to admin_review_path(review) }

      it do
        review.reload
        expect(review.rejected?).to eq true
      end
    end

    describe 'when batch actions' do
      before { post :batch_action, params: { batch_action: action, collection_selection: [review.id] } }

      context 'when approved' do
        let(:action) { I18n.t('admin.batches.approve').downcase }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to admin_reviews_path }

        it do
          review.reload
          expect(review.approved?).to eq true
        end
      end

      context 'when rejected' do
        let(:action) { I18n.t('admin.batches.reject').downcase }

        it { is_expected.to respond_with 302 }
        it { is_expected.to redirect_to admin_reviews_path }

        it do
          review.reload
          expect(review.rejected?).to eq true
        end
      end
    end

    it 'when delete batch action' do
      expect do
        post :batch_action, params: { batch_action: I18n.t('admin.batches.delete').downcase, collection_selection: [review.id] }
      end.to change(Review, :count).by(-1)
    end
  end

  describe 'when routes' do
    it { is_expected.to route(:get, '/admin/reviews').to(action: :index) }
    it { is_expected.to route(:get, '/admin/reviews/1').to(action: :show, id: 1) }
    it { is_expected.to route(:put, '/admin/reviews/1/rejected').to(action: :rejected, id: 1) }
    it { is_expected.to route(:put, '/admin/reviews/1/approved').to(action: :approved, id: 1) }
  end
end

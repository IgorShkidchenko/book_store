ActiveAdmin.register Review do
  permit_params :title, :body, :rating, :status, :book_id, :user_id

  actions :index, :show
  includes :book, :user

  scope :unprocessed, default: true
  scope :approved
  scope :rejected

  config.filters = false
  config.per_page = [10, 50, 100]

  Review::STATUSES.except(:unprocessed).each_pair do |key, value|
    action_item key, only: :show do
      if review.status == Review::STATUSES[:unprocessed]
        link_to Review::STATUSES[key],
                Review::STATUSES[:approved] == value ? approved_admin_review_path(review) : rejected_admin_review_path(review),
                method: :put
      end
    end

    member_action key, method: :put do
      review = Review.find(params[:id])
      review.update(status: Review::STATUSES[key])
      redirect_to admin_review_path(review)
    end
  end

  index do
    render 'admin/reviews/index', context: self
  end
end

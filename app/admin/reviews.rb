ActiveAdmin.register Review do
  permit_params :title, :body, :rating, :status, :book_id, :user_id

  actions :index, :show
  includes :book, :user

  scope :unprocessed, default: true
  scope :approved
  scope :rejected

  config.filters = false
  config.per_page = [10, 50, 100]

  batch_action :approve, priority: 1, if: proc { @current_scope.scope_method == :unprocessed } do |ids|
    Review.unprocessed.find(ids).each do |review|
      review.update(status: Review::STATUSES[:approved])
    end
    redirect_to admin_reviews_path
  end

  batch_action :reject, priority: 2, if: proc { @current_scope.scope_method == :unprocessed } do |ids|
    Review.unprocessed.find(ids).each do |review|
      review.update(status: Review::STATUSES[:rejected])
    end
    redirect_to admin_reviews_path
  end

  batch_action :destroy do |ids|
    Review.all.find(ids).each(&:destroy)
    redirect_to admin_reviews_path
  end

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

  action_item :show_on_site, only: :show do
    link_to t('admin.actions.show_on_site'), book_path(review.book) if review.status == Review::STATUSES[:approved]
  end

  index do
    selectable_column
    render 'admin/reviews/index', context: self
  end
end

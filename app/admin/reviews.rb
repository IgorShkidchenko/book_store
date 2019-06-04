ActiveAdmin.register Review do
  decorate_with ReviewDecorator

  permit_params :title, :body, :rating, :status, :book_id, :user_id

  actions :index, :show
  includes :book, :user

  scope :unprocessed, default: true
  scope :approved
  scope :rejected

  config.filters = false

  batch_action I18n.t('admin.batches.approve'), if: proc { @current_scope.scope_method == :unprocessed } do |ids|
    reviews = Review.unprocessed.where(id: ids)
    reviews.any? ? reviews.each(&:approved!) : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_reviews_path)
  end

  batch_action I18n.t('admin.batches.reject'), if: proc { @current_scope.scope_method == :unprocessed } do |ids|
    reviews = Review.unprocessed.where(id: ids)
    reviews.any? ? reviews.each(&:rejected!) : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_reviews_path)
  end

  batch_action I18n.t('admin.batches.delete') do |ids|
    reviews = Review.where(id: ids)
    reviews.any? ? reviews.destroy_all : flash[:danger] = I18n.t('admin.error.not_found')
    redirect_to(admin_reviews_path)
  end

  Review.statuses.except(:unprocessed).each_with_index do |(status, _), index|
    action_item status, only: :show do
      link_to status.capitalize,
              index.positive? ? rejected_admin_review_path(review) : approved_admin_review_path(review),
              method: :put
    end

    member_action status, method: :put do
      review = Review.find_by(id: params[:id])
      return admin_reviews_path, flash: { danger: I18n.t('admin.error.not_found') } unless review

      index.positive? ? review.rejected! : review.approved!
      redirect_to(admin_review_path(review))
    end
  end

  action_item :show_on_site, only: :show do
    link_to t('admin.actions.show_on_site'), book_path(review.book) if review.approved?
  end

  index do
    render 'admin/reviews/index', context: self
  end
end

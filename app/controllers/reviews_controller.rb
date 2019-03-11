class ReviewsController < ApplicationController
  authorize_resource
  respond_to :js

  def create
    review = ReviewForm.new(review_params)
    return flash[:success] = t('review.success_msg') if review.save

    flash[:danger] = review.errors.full_messages.to_sentence
  end

  private

  def review_params
    params.require(:review_form).permit(:title, :body, :rating, :book_id, :user_id)
  end
end

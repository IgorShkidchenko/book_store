class ReviewsController < ApplicationController
  def create
    review = ReviewForm.new(review_params)
    review.save ? flash[:success] = t('review.success_msg') : flash[:danger] = review.errors.full_messages.to_sentence
    redirect_back fallback_location: root_path
  end

  private

  def review_params
    params.require(:review_form).permit(:title, :body, :rating, :book_id, :user_id)
  end
end

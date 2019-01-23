class ReviewsController < ApplicationController
  def create
    review = Review.new review_params
    review.save ? flash[:success] = t('review.success_msg') : flash[:danger] = review.errors.full_messages.to_sentence
    redirect_to book_path(review.book_id)
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :rating, :book_id, :user_id)
  end
end

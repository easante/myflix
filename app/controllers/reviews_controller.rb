class ReviewsController < ApplicationController
  before_action :require_sign_in

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:notice] = "Review has been created."
    else
      flash[:alert] = "Review has not been created."
    end
    redirect_to video_path(:video_id)
  end

private
  def review_params
    params.require(:review).permit(:stars, :comment, :user_id, :video_id)
  end

end

class ReviewsController < ApplicationController
  before_action :require_sign_in

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
#raise @review.inspect
    @video = Video.find(params[:review][:video_id])
    if @review.save
      flash[:notice] = "Review has been created."
      redirect_to @video
    else
      flash[:alert] = "Review has not been created."
      render 'videos/show' 
    end
  end

private
  def review_params
    params.require(:review).permit(:stars, :comment, :user_id, :video_id)
  end

end

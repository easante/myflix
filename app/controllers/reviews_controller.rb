class ReviewsController < ApplicationController
  before_action :require_sign_in
  before_action :set_video

  def create
    @review = @video.reviews.build(review_params.merge!(user: current_user))
    if @review.save
      flash[:success] = "Review has been created."
      redirect_to @video
    else
      flash[:danger] = "Review has not been created."
      render 'videos/show' 
    end
  end

private
  def review_params
    params.require(:review).permit(:stars, :comment, :user_id, :video_id)
  end

  def set_video
    @video = Video.find(params[:video_id])
  end
end

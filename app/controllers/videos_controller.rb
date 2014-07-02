class VideosController < ApplicationController
  before_action :require_sign_in, except: [:front]

  def index
    @categories = Category.order(:name)
  end

  def show
    @video = VideoDecorator.decorate(Video.find params[:id])
    @review = @video.reviews.build
    @reviews = @video.reviews.order('created_at DESC')
    @review_count = @video.reviews.count
  end

  def front
    redirect_to home_path if current_user
  end

  def search
    @videos = Video.search_by_title(params[:search_word])
  end
end

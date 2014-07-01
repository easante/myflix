class Admin::VideosController < Admin::BaseController
  
  def new
    @video = Video.new
    @categories = Category.all
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Video has been created."
      redirect_to admin_add_video_path
    else
      flash[:danger] = "Video has not been created."
      render :new
    end
  end

private
  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :video_url)
  end
end

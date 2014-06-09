class QueueItemsController < ApplicationController
  before_action :require_sign_in

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    unless current_user.queue_items.map(&:video).include?(video)
      position = current_user.queue_items.count + 1
      @queue_items = QueueItem.new(queue_item_params.merge!(user: current_user, position: position))
      @queue_items.save
    end
    redirect_to queue_items_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy
    redirect_to queue_items_path
  end

private
  def queue_item_params
    params.permit(:video_id, :user_id, :position)
  end
end

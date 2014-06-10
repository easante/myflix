class QueueItemsController < ApplicationController
  before_action :require_sign_in

  def index
    @queue_items = current_user.queue_items.order(:position)
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

  def update
    ordered_queue = QueueItem.re_order(params[:queue_items])
    ActiveRecord::Base.transaction do
      ordered_queue.each_with_index do |row|
        queue_item = QueueItem.find(row[1])
        unless queue_item.update(queue_item_params.merge!(user: current_user, position: row[0]))
          flash[:alert] = "Position has to be an integer number."
          redirect_to queue_items_path
          return
        end
      end
      current_user.normalize_positions
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

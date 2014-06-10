class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates :video_id, :user_id, presence: true
  #validates :position, presence: true
  validates :position, numericality: { only_integer: true }

  def self.re_order(items)
    pos_array = []
    items.each do |queue_item|
      pos_array << [queue_item[:position], queue_item[:id]]
    end
    pos_array.sort!
  end

default_scope { order(:position) } 

#  def video_title
#    video.title
#  end

  def category_name
    category.name
  end

#  def category_name
#    video.category.name
#  end

#  def category
#   video.category if video 
#  end
end

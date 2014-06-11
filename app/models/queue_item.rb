class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  default_scope { order(:position) } 

  validates :video_id, :user_id, presence: true
  validates :position, numericality: { only_integer: true }

  def self.re_order(items)
    pos_array = []
    items.each do |queue_item|
      pos_array << [queue_item[:position], queue_item[:id], queue_item[:stars]]
    end
    pos_array.sort!
  end

  def star_rating
    user_review.stars if user_review
  end

  def star_rating=(stars)
    if user_review
      user_review.update(stars: stars)
    else
      review = Review.new(user: user, video: video, stars: stars)
      review.save(validate: false)
    end
  end

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

private
  def user_review
    @user_review ||= user.reviews.where(video_id: video.id).first
  end
end

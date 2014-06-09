class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  STARS = [5, 4, 3, 2, 1]
  validates :comment, presence: true
  validates :user_id, presence: true
  validates :video_id, presence: true
  validates :stars, inclusion: {
    in: STARS,
    message: "must be between 1 and 5"
  }

end

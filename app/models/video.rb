class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(title)
    where('title LIKE ?', "%#{title}%").order(:title)
  end

  def rating
    reviews.average(:stars).round(1) unless reviews.average(:stars).nil?
  end
end

class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(title)
    where('title LIKE ?', "%#{title}%").order(:title)
  end
  
  def rating
    #reviews.average(:stars).round(1) if reviews.average(:stars)
    return 0 if reviews.size == 0
    sum = 0.0
    reviews.each do |r| 
      sum += r.stars if r.stars
    end
    return sum / reviews.size
  end
end

class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(title)
    where('title LIKE ?', "%#{title}%").order(:title)
  end
  
  def rating
    stars = reviews.map { |r| r.stars }
    stars.inject(:+).to_f / stars.size 
  end
end

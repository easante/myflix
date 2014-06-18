class User < ActiveRecord::Base
  has_many :queue_items
  has_many :reviews
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_secure_password validations: false

  validates :full_name, presence: true  
  validates :email, presence: true  

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def follows_or_same?(new_friend)
    #binding.pry
    friendships.map(&:friend).include?(new_friend) || self == new_friend
  end

  def normalize_positions
      queue_items.each_with_index do |queue_item, index|
        queue_item.update(position: index + 1)
      end
  end
end

class User < ActiveRecord::Base
  has_many :queue_items
  has_many :reviews
  has_secure_password validations: false

  validates :full_name, presence: true  
  validates :email, presence: true  

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    user && user.authenticate(password)
  end

  def normalize_positions
      queue_items.each_with_index do |queue_item, index|
        queue_item.update(position: index + 1)
      end
  end
end

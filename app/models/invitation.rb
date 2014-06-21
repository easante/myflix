#require_relative '../../lib/tokenable'

class Invitation < ActiveRecord::Base
  include Tokenable

  validates :full_name, presence: true
  validates :email, presence: true
  validates :message, presence: true

  belongs_to :inviter, class_name: "User"

end

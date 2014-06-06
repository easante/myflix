module ApplicationHelper
  def reviewer(review)
    user = User.find_by(id: review.user_id)
    user ? user.full_name : "None"
  end
end

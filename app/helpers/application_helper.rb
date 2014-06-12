module ApplicationHelper
  def reviewer(review)
    user = User.find_by(id: review.user_id)
    user ? user.full_name : "None"
  end

  def ratings_values
    Review::STARS.map { |s| ["#{pluralize(s, 'Star')}", s] }
  end

  def queue_includes?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end

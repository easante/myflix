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

  def queue_count(user)
    user.queue_items.count
  end

  def queue_video(queue_item)
    queue_item.video.title
  end

  def queue_category(queue_item)
    queue_item.video.category.name if queue_item
  end
end

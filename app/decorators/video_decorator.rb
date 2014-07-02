class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating > 0 ? "#{sprintf('%.1f', object.rating)} /5.0" : "N/A"
  end
end

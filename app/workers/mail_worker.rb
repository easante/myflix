class MailWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    WelcomeMailer.notify_on_sign_up(user).deliver
  end
end

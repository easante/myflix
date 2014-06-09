class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_sign_in
    unless current_user
      redirect_to new_session_path, alert: "Please sign in first!"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end

  helper_method :current_user

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?
end

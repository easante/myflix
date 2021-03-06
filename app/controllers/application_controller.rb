class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_sign_in
    unless current_user
      flash[:danger] = "Please sign in first!"
      redirect_to sign_in_path
    end
  end

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You have to be an admin to do that."
      redirect_to home_path
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

class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      flash[:success] = "Sign in successful."
      redirect_to home_path
    else
      flash[:danger] = "Invalid email/password combination."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have been signed out."
    redirect_to root_path
  end
end

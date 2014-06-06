class SessionsController < ApplicationController
  def new
    redirect_to home_path if session[:user_id]
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Sign in successful."
      redirect_to home_path
    else
      flash[:alert] = "Invalid email/password combination."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have been signed out."
  end
end

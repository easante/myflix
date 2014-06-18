class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      WelcomeMailer.notify_on_sign_up(@user).deliver
      flash[:notice] = "You have signed up successfully."
      redirect_to sign_in_path
    else
      flash[:alert] = "Sign up unsuccessful."
      render :new
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :full_name) 
  end
end

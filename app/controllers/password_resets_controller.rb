class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      WelcomeMailer.send_password_link(user).deliver
      render :confirm_password_reset
      false
    else
      flash[:error] = params[:email] ? "Email invalid." : "Email can't be blank."
      redirect_to reset_password_path
    end
  end

  def edit
    @user = User.find_by(token: params[:id])
    redirect_to expired_token_path unless @user
  end


  def update
    @user = User.find_by(token: params[:id])
    if @user
      @user.password = params[:user][:password]
      @user.generate_token
      @user.save
      flash[:notice] = "Password has been changed."
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  def expired_token
  end

private
  def user_params
    params.require(:user).permit(:token, :password)
  end
end

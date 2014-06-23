class UsersController < ApplicationController
  def new
    @user = User.new
    @invitation = Invitation.find_by(token: params[:invitation_id]) if params[:invitation_id]
    @user.email = @invitation.email if @invitation
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    unless params[:user][:invitation_id].nil?
      @invitation = Invitation.find_by(token: params[:user][:invitation_id]) 
      if @invitation.nil?
        flash[:notice] = "Invalid token."
        redirect_to register_path 
        return
      end
    end

    if @user.save
      if @invitation
        @user.follow(@invitation.inviter)
        @invitation.inviter.follow(@user)
        @invitation.token = nil
        @invitation.save
      end
      MailWorker.perform_async(@user.id)
      #WelcomeMailer.delay.notify_on_sign_up(@user)
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

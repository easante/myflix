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

    verify_invitation

    if @user.save
      @user.handle_invitation(@invitation)

      token = params[:stripeToken]
      charge = StripeWrapper::Charge.create(:amount => 999, :card => token,
            :description => "Sign up charge for #{@user.email}")
      if charge.successful?
        MailWorker.perform_async(@user.id)
        flash[:success] = "Thank you for your business"
        redirect_to sign_in_path
      else
        flash[:danger] = charge.error_message
        flash[:danger] += "\n\nSign up unsuccessful."
        redirect_to register_path
        return
      end

      #MailWorker.perform_async(@user.id)
      #WelcomeMailer.delay.notify_on_sign_up(@user)

      #flash[:success] = "You have signed up successfully."
      #redirect_to sign_in_path
    else
      flash[:danger] = "Sign up unsuccessful."
      #require 'pry'; binding.pry

      render 'new'
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def verify_invitation
    unless params[:user][:invitation_id].nil?
      @invitation = Invitation.find_by(token: params[:user][:invitation_id])
      if @invitation.nil?
        flash[:success] = "Invalid token."
        redirect_to register_path
        return
      end
    end
  end
end

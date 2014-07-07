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
    outcome = SignUpHandling.new(@user).sign_up(params[:user][:invitation_id], params[:stripeToken])
    if outcome.invalid_invitation?
      flash[:danger] = "Invalid token."
      redirect_to register_path
      return
    end

    if outcome.successful?
      flash[:success] = "Thank you for your business"
      redirect_to sign_in_path
    else
      flash[:danger] = outcome.error_message
      render :new
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end

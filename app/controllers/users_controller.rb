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

      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      token = params[:stripeToken]
      begin
        charge = Stripe::Charge.create(
          :amount => 999,
          :currency => "cad",
          :card => token,
          :description => "Sign up charge for #{@user.email}"
        )
      rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_payment_path
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

  def verify_invitation
    unless params[:user][:invitation_id].nil?
      @invitation = Invitation.find_by(token: params[:user][:invitation_id]) 
      if @invitation.nil?
        flash[:notice] = "Invalid token."
        redirect_to register_path 
        return
      end
    end
  end
end

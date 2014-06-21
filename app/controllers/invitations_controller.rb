class InvitationsController < ApplicationController
  before_action :require_sign_in

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter: current_user))
    if @invitation.save
      WelcomeMailer.send_invitation_link(@invitation).deliver 
      flash[:notice] = "Friend's invitation has been sent."
      redirect_to home_path
    else
      flash[:alert] = "Friend's details/message can't be blank."
      render :new
    end
  end

private
  def invitation_params
    params.require(:invitation).permit(:full_name, :email, :message, :inviter_id)
  end
end

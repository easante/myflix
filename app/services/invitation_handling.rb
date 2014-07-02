class InvitationHandling
  attr_reader   :invitation_param, :user
  attr_accessor :invitation

  def initialize(invitation_param, user)
    @invitation_param = invitation_param
    @user = user
  end

  def invalid_invitation?
    has_invitation? && !valid_invitation?
  end

  def handle_invitation
    if invitation
      user.follow(invitation.inviter)
      invitation.inviter.follow(user)
      invitation.token = nil
      invitation.save
    end
  end

private
  def has_invitation?
    !invitation_param.nil?
  end

  def valid_invitation?
    unless invitation_param.nil?
      invitation = Invitation.find_by(token: invitation_param)
    end
  end
end

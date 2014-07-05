class SignUpHandling
  attr_reader   :user, :error_message
  attr_accessor :invitation, :invitation_token

  def initialize(user)
    @user = user
  end

  def successful?
    @status == :success
  end

  def invalid_invitation?
    has_invitation? && invitation
  end

  def sign_up(invite_token, stripe_token)
    invitation_token = invite_token
    @invitation = Invitation.find_by(token: invite_token)

    if invalid_invitation?
      @status = :failure
      self
    end

    if user.valid?
      token = stripe_token
      #charge = StripeWrapper::Charge.create(:amount => 999, :card => token,
      #      :description => "Sign up charge for #{user.email}")
      customer = StripeWrapper::Customer.create(:card => token,
            :email => user.email)

      if customer.successful?
        user.customer_token = customer.customer_token
        user.save
        handle_invitation
        MailWorker.perform_async(user.id)
        @status = :success
        self
      else
        @status = :failure
        @error_message = customer.error_message
        self
      end
    else
      @status = :failure
      @error_message = "Invalid user information."
      #raise error_message.inspect
      self
    end
  end

private
  def handle_invitation
    if invitation
      user.follow(invitation.inviter)
      invitation.inviter.follow(user)
      invitation.token = nil
      invitation.save
    end
  end

  def has_invitation?
    !invitation_token.nil?
  end

  # def valid_invitation?
  #   unless invitation_token.nil?
  #     #require 'pry'; binding.pry
  #     #@invitation = Invitation.find_by(token: invitation_token)
  #   end
  # end
end

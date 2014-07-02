class CardProcessing
  attr_reader :token, :user, :amount

  def initialize(token, user, amount)
    @token = token
    @user = user
    @amount = amount
  end

  def charge_card
    charge = StripeWrapper::Charge.create(:amount => amount, :card => token,
          :description => "Sign up charge for #{user.email}")
    if charge.successful?
      MailWorker.perform_async(user.id)
    end
    charge
  end
end

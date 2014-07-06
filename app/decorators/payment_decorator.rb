class PaymentDecorator < Draper::Decorator
  delegate_all

  def charge
    "#{ActionController::Base.helpers.number_to_currency(object.amount/100.0)}"
  end
end

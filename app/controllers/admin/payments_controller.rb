class Admin::PaymentsController < Admin::BaseController
  def index
    @payments = PaymentDecorator.decorate_collection(Payment.all.limit(10))
    #raise @payments.inspect
  end
end

# config/initializers/stripe.rb
Stripe.api_key = ENV['STRIPE_SECRET_KEY'] # Set your api key

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(customer_token: event.data.object.customer)
    amount = event.data.object.amount
    reference_id = event.data.object.id

    Payment.create(user: user, amount: amount, reference_id: reference_id)
  end
end

require 'spec_helper'

describe StripeWrapper do
  before do
    StripeWrapper.set_api_key
  end

  let(:valid_card_number) { '4242424242424242' }
  let(:declined_card_number) {'4000000000000002'}

  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => valid_card_number,
        :exp_month => 10,
        :exp_year => 2016,
        :cvc => 314
      }
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number => declined_card_number,
        :exp_month => 10,
        :exp_year => 2016,
        :cvc => 314
      }
    ).id
  end

  describe StripeWrapper::Charge do
    context "with a valid card" do
      it "charges the amount to the card successfully" do
        response = StripeWrapper::Charge.create(amount: 999, card: valid_token)
        expect(response).to be_successful
      end
    end

    context "with an invalid card" do
      let(:response) { StripeWrapper::Charge.create(amount: 999, card: declined_token) }

      it "does not charge the amount to the card successfully" do
        expect(response).not_to be_successful
      end

      it "returns an error message" do
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".customer" do
      it "creates a customer with a valid card" do
        john = Fabricate(:user, email: 'john@email.com')
        subscription = StripeWrapper::Customer.create(plan: "flix_plan", card: valid_token, email: john.email)
        expect(subscription).to be_successful
      end

      it "does not create a customer with a declined card" do
        john = Fabricate(:user, email: 'john@email.com')
        subscription = StripeWrapper::Customer.create(plan: "flix_plan", card: declined_token, email: john.email)
        expect(subscription).not_to be_successful
      end

      it "returns the customer token for a valid card" do
        john = Fabricate(:user)
        subscription = StripeWrapper::Customer.create(plan: "flix_plan", card: valid_token, email: john.email)
        expect(subscription.customer_token).to be_present

      end

      it "returns an error message for a declined card" do
        john = Fabricate(:user, email: 'john@email.com')
        subscription = StripeWrapper::Customer.create(plan: "flix_plan", card: declined_token, email: john.email)
        expect(subscription.error_message).to eq('Your card was declined.')
      end

      it "returns the customer token for a valid card" do
        john = Fabricate(:user, email: 'john@email.com')
        subscription = StripeWrapper::Customer.create(plan: "flix_plan", card: valid_token, email: john.email)
        expect(subscription.customer_token).to be_present

      end
    end
  end
end

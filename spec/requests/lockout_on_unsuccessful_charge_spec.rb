require "spec_helper"

describe "Lock subscriber out on unsuccessful charge" do
  let(:event_data) do
    {
      "id" => "evt_14DG0f4OlWR9sB6HOlmWoGe6",
      "created" => 1404654533,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_14DG0f4OlWR9sB6HA54AOgbR",
          "object" => "charge",
          "created" => 1404654533,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "card" => {
            "id" => "card_14DFz04OlWR9sB6HXMPOhTa6",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 7,
            "exp_year" => 2015,
            "fingerprint" => "aLIIcu79TagoccUX",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4Lfjy5EmkkvgLZ"
          },
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14DG0f4OlWR9sB6HA54AOgbR/refunds",
            "data" => []
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4Lfjy5EmkkvgLZ",
          "invoice" => nil,
          "description" => "Made to Fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4LxwHMriSTyWCj"
    }
  end

  it "it does not create a payment with the webhook from stripe for unsuccessful charge" do
    john = Fabricate(:user, customer_token: "cus_4Lfjy5EmkkvgLZ")

    post "/stripe_events", event_data
    expect(john.reload).not_to be_active
  end

  it "it sends notification email to subscriber" do
    john = Fabricate(:user, customer_token: "cus_4Lfjy5EmkkvgLZ")

    post "/stripe_events", event_data
    expect(ActionMailer::Base.deliveries.last.to).to eq([john.email])
  end
end

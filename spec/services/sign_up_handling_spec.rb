require 'spec_helper'

describe SignUpHandling do
  describe "#sign_up" do
    context "valid user and card information" do
      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates a user record for valid inputs" do
        SignUpHandling.new(Fabricate.build(:user)).sign_up(nil, "123")
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        juliet = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: juliet.id, email: 'john@example.com')
        SignUpHandling.new(Fabricate.build(:user, email: 'john@example.com', password: 'password', full_name: 'John Bull')).sign_up(invitation.token, "123")
        john = User.find_by(email: 'john@example.com')
        expect(john.follows?(juliet)).to be_true
      end

      it "makes the inviter follow the user" do
        juliet = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: juliet.id, email: 'john@example.com')
        SignUpHandling.new(Fabricate.build(:user, email: 'john@example.com', password: 'password', full_name: 'John Bull')).sign_up(invitation.token, "123")
        john = User.find_by(email: 'john@example.com')
        expect(juliet.follows?(john)).to be_true
      end

      it "expires the invitation token" do
        juliet = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter_id: juliet.id, email: 'john@example.com')
        SignUpHandling.new(Fabricate.build(:user, email: 'john@example.com', password: 'password', full_name: 'John Bull')).sign_up(invitation.token, "123")
        john = User.find_by(email: 'john@example.com')
        expect(Invitation.last.token).to be_nil
      end

      it "sends out email for valid user input" do
        SignUpHandling.new(Fabricate.build(:user, email: 'john@example.com')).sign_up(nil, "123")
        expect(ActionMailer::Base.deliveries.last.to).to eq(['john@example.com'])
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        SignUpHandling.new(Fabricate.build(:user)).sign_up(nil, "123")
        expect(User.count).to eq(0)
      end
    end

    context "invalid personal information" do
      it "does not create a user record" do
        user = User.new(email: 'john@example.com')
        SignUpHandling.new(user).sign_up(nil, "123")
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        user = User.new(email: 'john@example.com')
        StripeWrapper::Charge.should_not_receive(:create)
        SignUpHandling.new(user).sign_up(nil, "123")
      end

      it "does not send out email with invalid inputs" do
        ActionMailer::Base.deliveries.clear

        user = User.new(email: 'john@example.com')
        SignUpHandling.new(user).sign_up(nil, "123")
        #require 'pry'; binding.pry
        #expect(ActionMailer::Base.deliveries).to be_empty
        expect(ActionMailer::Base.deliveries).to match_array([])
      end
    end
  end
end

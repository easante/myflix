require 'spec_helper'

describe UsersController do

  describe "GET new" do
    before do
      set_current_user
    end

    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "assigns a new invitation to @invitation" do
      invitation = Invitation.create(full_name: "John", email: "john@example.com", message: "message")
      get :new
      expect(Invitation.count).to eq(1)
    end

    it "sets the password to invitees password if invitation exists" do
      invitation = Invitation.create(full_name: "John", email: "john@example.com", message: "message")
      user = Fabricate(:user, email: invitation.email)
      get :new
      expect(user.email).to eq('john@example.com')
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "GET show" do
    it "displays a user profile" do
      john = Fabricate(:user)
      get :show, id: john.id
      expect(assigns(:user)).to eq(john)
    end

    it "displays a user profile" do
      john = Fabricate(:user)
      get :show, id: john.id
      expect(response).to render_template :show
    end
  end

  describe "POST create" do
    let(:charge) { double('charge') }
    before do
      charge = double('charge')
      charge.stub(:successful?).and_return(true)
      StripeWrapper::Charge.stub(:create).and_return(charge)
    end

    it "creates a user record for valid inputs" do

      post :create, user: { full_name: 'Juliet Asiedu', email: 'juliet@example.com', password: 'password' }, charge: charge
      expect(User.first.full_name).to eq('Juliet Asiedu')
    end

    it "redirects to the sign_in_path" do
      post :create, user: { full_name: 'Juliet Asiedu', email: 'juliet@example.com', password: 'password' }, charge: charge
      expect(response).to redirect_to sign_in_path
    end

    it "renders the new template when invalid user data is entered" do
      post :create, user: { email: 'juliet@example.com', password: 'password' }, charge: charge
      expect(response).to render_template :new
    end

    context "sending email" do
      it "sends out email" do
        post :create, user: { "email"=>"connie@example.com", "password"=>"password", "full_name"=>"Comfort Ohenebeng" }, charge: charge
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email to the right receipient" do
        post :create, user: { "email"=>"connie@example.com", "password"=>"password", "full_name"=>"Comfort Ohenebeng" }, charge: charge
        expect(ActionMailer::Base.deliveries.last.to).to eq(["connie@example.com"])
      end

      it "sends out the right email body" do
        post :create, user: { "email"=>"connie@example.com", "password"=>"password", "full_name"=>"Comfort Ohenebeng" }, charge: charge
        expect(ActionMailer::Base.deliveries.last.body).to include("Thank you for signing up")
      end
    end

#    context "creating a user from invitation" do
#      it "creates friendships from valid invitation token" do
#        john = Fabricate(:user)
#        invitation = Fabricate(:invitation, inviter_id: john.id, email: "mike@example.com", full_name: "Mike", message: "Message")
#        post :create, user: { email: invitation.email, password: "password", full_name: invitation.full_name, invitation_id: invitation.id }
#        mike = User.find_by(email: "mike@example.com")
#        expect(mike.follows_or_same?(john)).to be_true
#        #expect(john.follows_or_same?(mike)).to be_true
#      end
#    end
  end

end

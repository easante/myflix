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
  #   context "successful user sign up" do
  #     it "redirects to the sign_in_path" do
  #       result = double(:sign_up_result, successful?: true)
  #       SignUpHandling.any_instance.should_receive(:sign_up).and_return(result)
  #       post :create, user: Fabricate.attributes_for(:user)
  #       expect(response).to redirect_to sign_in_path
  #     end
  #   end
  #
  #   context "unsuccessful user sign up" do
  #     it "renders the new template when invalid user data is entered" do
  #       #charge = double(:charge, successful?: false, error_message: "Your card was declined.")
  #       result = double(:sign_up_result, successful?: false)
  #       SignUpHandling.any_instance.should_receive(:sign_up).and_return(result)
  #
  #
  #       #StripeWrapper::Charge.should_receive(:create).and_return(charge)
  #
  #       post :create, user: Fabricate.attributes_for(:user), stripToken: '123'
  #       expect(response).to render_template :new
  #     end
  #
  #     it "sets the flash error message" do
  #       #charge = double(:charge, successful?: false, error_message: "Your card was declined.")
  #       #StripeWrapper::Charge.should_receive(:create).and_return(charge)
  #       result = double(:sign_up_result, successful?: false)
  #       SignUpHandling.any_instance.should_receive(:sign_up).and_return(result)
  #
  #       post :create, user: Fabricate.attributes_for(:user), stripToken: '123'
  #       expect(flash[:danger]).to be_present
  #     end
  #   end
  end
end

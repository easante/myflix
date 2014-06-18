require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
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
    it "creates a user record for valid inputs" do
      post :create, user: { full_name: 'Juliet Asiedu', email: 'juliet@example.com', password: 'password' } 
      expect(User.first.full_name).to eq('Juliet Asiedu')
    end

    it "redirects to the sign_in_path" do
      post :create, user: { full_name: 'Juliet Asiedu', email: 'juliet@example.com', password: 'password' } 
      expect(response).to redirect_to sign_in_path
    end

    it "renders the new template when invalid user data is entered" do
      post :create, user: { email: 'juliet@example.com', password: 'password' } 
      expect(response).to render_template :new
    end

    context "sending email" do
      it "sends out email" do
        post :create, user: { "email"=>"connie@example.com", "password"=>"password", "full_name"=>"Comfort Ohenebeng" }
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email to the right receipient" do
        post :create, user: { "email"=>"connie@example.com", "password"=>"password", "full_name"=>"Comfort Ohenebeng" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["connie@example.com"])
      end

      it "sends out the right email body" do
        post :create, user: { "email"=>"connie@example.com", "password"=>"password", "full_name"=>"Comfort Ohenebeng" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Thank you for signing up")
      end
    end
  end

end

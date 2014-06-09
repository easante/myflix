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
  end

end

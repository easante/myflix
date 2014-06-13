require 'spec_helper'

describe SessionsController do
  before do
    set_current_user
  end

  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      clear_current_user

      get :new
      expect(response).to render_template :new
    end

    it "redirects to the home page for authenticated users" do
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "successful sign in" do
      before do
      clear_current_user
      user = Fabricate(:user)

        post :create, { email: user.email, password: user.password }
      end

      it "redirects to home_path" do
        expect(response).to redirect_to home_path
      end
  
      it "sets the flash message" do
        expect(flash[:notice]).to eq('Sign in successful.')
      end

      it "creates a session record for valid inputs" do
        expect(session[:user_id]).to eq(current_user.id)
      end
  
    end

    context "unsuccessful sign in" do
      it "renders the sign in page" do
        post :create, email: current_user.email, password: "mypassword" 
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    it "logs the user out" do
      session[:user_id] = current_user.id
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the the root path" do
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end

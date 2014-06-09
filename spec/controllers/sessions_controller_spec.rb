require 'spec_helper'

describe SessionsController do

  describe "GET new" do
    it "renders the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "successful sign in" do
      let(:juliet) { Fabricate(:user) }

      before do
        post :create, email: juliet.email, password: juliet.password 
      end

      it "creates a session record for valid inputs" do
        expect(session[:user_id]).to eq(juliet.id)
      end
  
      it "redirects to home_path" do
        expect(response).to redirect_to home_path
      end
  
      it "sets the flash message" do
        expect(flash[:notice]).to eq('Sign in successful.')
      end
    end

    context "unsuccessful sign in" do
      it "renders the sign in page" do
        juliet =  Fabricate(:user) 
        post :create, email: juliet.email, password: "mypassword" 
        expect(response).to render_template :new
      end
    end
  end

  describe "GET destroy" do
    it "logs the user out" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the the root path" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end

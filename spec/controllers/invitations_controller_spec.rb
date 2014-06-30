require 'spec_helper'

describe InvitationsController do
  let(:john) { Fabricate(:user) }

  before do
    set_current_user
  end

  describe "GET new" do
    it "assigns a new invitation to @invitation" do
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    context "unauthenticated users" do
      it "redirects to sign in page" do
        clear_current_user

        post :create, invitation: { full_name: "John", email: "mike@example.com", message: "My test message", token:"" }
        expect(response).to redirect_to sign_in_path
      end

      it "displays error message" do
        clear_current_user
        post :create, invitation: { full_name: "John", email: "mike@example.com", message: "My test message", token:"" }
        expect(flash[:danger]).to eq("Please sign in first!")
      end
    end

    context "authenticated users" do
      context "no full name filled in" do
        it "renders the new template" do
          post :create, invitation: { full_name: "", email: "mike@example.com", message: "My test message" }
          expect(response).to render_template :new
        end

        it "displays error message" do
          post :create, invitation: { full_name: "", email: "mike@example.com", message: "My test message" }
          expect(flash[:danger]).to eq("Friend's details/message can't be blank.")
        end
      end

      context "no email address filled in" do
        it "renders the new template" do
          post :create, invitation: { full_name: "Mike", email: "", message: "My test message" }
          expect(response).to render_template :new
        end

        it "displays error message" do
          post :create, invitation: { full_name: "Mike", email: "", message: "My test message" }
          expect(flash[:danger]).to eq("Friend's details/message can't be blank.")
        end
      end

      context "no message filled in" do
        it "renders the new template" do
          post :create, invitation: { full_name: "Mike", email: "mike@example.com", message: "" }
          expect(response).to render_template :new
        end

        it "displays error message" do
          post :create, invitation: { full_name: "Mike", email: "mike@example.com", message: "" }
          expect(flash[:danger]).to eq("Friend's details/message can't be blank.")
        end
      end

      context "successful creation of invitation" do
        it "saves the invitation" do
          post :create, invitation: { full_name: "Mike", email: "mike@example.com", message: "Awesome site", token: "12345" }
          expect(Invitation.count).to eq(1)
        end

        it "sends an email to invitee" do
          post :create, invitation: { full_name: "Mike", email: "mike@example.com", message: "Awesome site", token: "12345" }
          expect(ActionMailer::Base.deliveries.last.to).to eq(["mike@example.com"])
        end

        it "displays a flash message to indicate success" do
          post :create, invitation: { full_name: "Mike", email: "mike@example.com", message: "Awesome site", token: "12345" }
          expect(flash[:success]).to eq("Friend's invitation has been sent.")
        end

        it "redirects to the home page" do
          post :create, invitation: { full_name: "Mike", email: "mike@example.com", message: "Awesome site", token: "12345" }
          expect(response).to redirect_to(home_path)
        end
      end
    end
  end
end

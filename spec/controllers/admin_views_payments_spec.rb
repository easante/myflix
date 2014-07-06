require 'spec_helper'

describe Admin::PaymentsController do
  describe "GET index" do
    context "admin users" do
      before do
        set_current_admin
      end

      it "assigns the admin user's new most recent payment records to @payments" do
        payment1 = Fabricate(:payment)
        payment2 = Fabricate(:payment)

        get :index
        expect(assigns(:payments)).to match_array([payment1, payment2])
      end

      it "renders the index template" do
        payment = Fabricate(:payment)

        get :index
        expect(response).to render_template :index
      end
    end

    context "non-admin users" do
      it "redirects to the home page if not an admin user" do
        set_current_user

        get :index
        expect(response).to redirect_to home_path
      end
    end
  end
end

require 'spec_helper'

describe FriendshipsController do
  describe "POST create" do
    before do
      set_current_user
    end

    context "authenticated users" do
      let(:jack) { Fabricate(:user) }
      let(:mary) { Fabricate(:user) }

      it "creates friendship with valid inputs for authenticated users" do
        post :create, { friend_id: jack.id, user_id: current_user.id }
        expect(Friendship.count).to eq(1)
      end

      it "fails to create friendship if already a friend for authenticated users" do
        friend = Fabricate(:friendship, user_id: current_user.id, friend_id: jack.id)

        post :create, Fabricate.attributes_for(:friendship, user_id: current_user.id, friend_id: jack.id)
        expect(response).to redirect_to user_path(jack.id)
      end

      it "redirects to the people show page" do
        friendship = Fabricate(:friendship, friend_id: jack.id, user_id: current_user.id)

        #post :create, { friend_id: mary.id, user_id: current_user.id}
        post :create, Fabricate.attributes_for(:friendship, user_id: current_user.id, friend_id: jack.id)
        expect(response).to redirect_to people_path
      end
    end

    context "unauthenticated users" do
      let(:jack) { Fabricate(:user) }

      it "fails to create a friendship for unauthenticated users" do
        clear_current_user

        post :create, friendship: { friend_id: jack.id }
        expect(response).to redirect_to new_session_path
      end
    end
  end
end

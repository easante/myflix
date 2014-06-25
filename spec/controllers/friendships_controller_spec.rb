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
        post :create, Fabricate.attributes_for(:friendship, user_id: current_user.id, friend_id: jack.id)
        expect(current_user.friendships.first.friend).to eq(jack)
      end

      it "fails to create friendship if already a friend of authenticated user" do
        friendship = Fabricate(:friendship, user_id: current_user.id, friend_id: jack.id)

        post :create, Fabricate.attributes_for(:friendship, user_id: current_user.id, friend_id: jack.id)
        expect(Friendship.count).to eq(1)
      end

      it "redirects to the people page" do

        post :create, Fabricate.attributes_for(:friendship, user_id: current_user.id, friend_id: mary.id)
        expect(response).to redirect_to people_path
      end

      it "does not create association with itself" do
        friendship = Fabricate(:friendship, user_id: current_user.id, friend_id: jack.id)

        post :create, Fabricate.attributes_for(:friendship, user_id: current_user.id, friend_id: current_user.id)
        expect(Friendship.count).to eq(1)
      end
    end

    context "unauthenticated users" do
      let(:jack) { Fabricate(:user) }

      it "fails to create a friendship for unauthenticated users" do
        clear_current_user

        post :create, friendship: { friend_id: jack.id }
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end

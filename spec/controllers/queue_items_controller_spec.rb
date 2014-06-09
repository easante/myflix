require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do
#    it "assigns the current user's new queue_item records to @queue_items" do
#      user = Fabricate(:user)
#      session[:user_id] = user.id
#      item1 = Fabricate(:queue_item, position: 1)
#      item2 = Fabricate(:queue_item, position: 2)
#
#      get :index
#      #expect(assigns(:queue_items)).to include item1
#      #expect(assigns(:queue_items)).to eq([item1, item2])
#      expect(assigns(:queue_items)).to match_array([item1, item2])
#    end

    it "renders the index template" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user.id
      item = Fabricate(:queue_item, video: video, user: user)

      get :index
      expect(response).to render_template :index
    end

    it "redirects to the sign_in page if not authenticated" do
      get :index
      expect(response).to redirect_to new_session_path
    end
  end

  describe "POST create" do
    it "creates a queue_item record" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user.id

      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to the queue_items path" do
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id

      post :create, video_id: video.id
      expect(response).to redirect_to queue_items_path
    end

    it "puts the item as the last one" do
      first_video = Fabricate(:video)
      user = Fabricate(:user)
      session[:user_id] = user.id
      item = Fabricate(:queue_item, video: first_video, user: user)
      position = QueueItem.count + 1
      last_video = Fabricate(:video)

      post :create, video_id: last_video.id
      expect(QueueItem.last.position).to eq(position)
    end

    it "assigns the current user with the queue item" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)

      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)
    end

    it "redirects to the sign_in path" do
      video = Fabricate(:video)

      post :create, video_id: video.id
      expect(response).to redirect_to new_session_path
    end
  end

  describe "DELETE destroy" do
    it "deletes a queue_item record from the database" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item)
      count = QueueItem.count - 1
      session[:user_id] = user.id

      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(count)
    end
  end

end

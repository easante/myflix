require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it "assigns a new video to @video" do
      set_current_admin

      get :new
      expect(assigns(:video)).to be_instance_of(Video)
    end

    it "sets the @categories variable" do
      set_current_admin
      cat1 = Fabricate(:category)
      cat2 = Fabricate(:category)

      get :new
      expect(assigns(:categories)).to match_array [cat1, cat2]
    end
 
    it "redirects non-admin user to the home page" do
      set_current_user

      get :new
      expect(response).to redirect_to home_path
    end
  end


  describe "POST create" do
    it "redirects non-admin users to the home page" do
      set_current_user

      post :create, video: {title: 'Despicable', description: "Me", category_id: 1} 
      expect(response).to redirect_to home_path
    end

    it "sets the flash alert message for non-admin users" do
      set_current_user

      post :create, video: {title: 'Despicable', description: "Me", category_id: 1} 
      expect(flash[:alert]).to eq("You have to be an admin to do that.")
    end

    it "creates the video for admin users" do
      set_current_admin

      post :create, video: {title: 'Despicable', description: "Me", category_id: 1} 
      expect(Video.count).to eq(1)
    end

    it "creates the video for admin users" do
      set_current_admin

      #require 'pry'; binding.pry
      post :create, video: {title: "Despicable", description: "Me", category_id: 1, video_url: "http://www.example.com/video.mp4" } 
      expect(flash[:notice]).to eq("Video has been created.")
    end
  end

end

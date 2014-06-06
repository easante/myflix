require 'spec_helper'

describe VideosController do

  describe "GET show" do
    it "assigns the requested video to @video" do
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:video)).to eq video
    end

    it "assigns a new review to @review" do
      video = Fabricate(:video)
      review = Fabricate(:review)
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:review)).to eq review
    end

    it "renders the show template" do
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(response).to render_template :show
    end
  end

  describe "POST search" do
    it "returns the video that matches the search string" do
      futurama = Fabricate(:video, title: 'Futurama')
      session[:user_id] = Fabricate(:user).id

      post :search, search_word: 'Futu'
      expect(assigns(:videos)).to eq [futurama]
    end

    it "redirects to the sign in page for unauthenticated user" do
      futurama = Video.create(title: 'Futurama', description: 'Cartoon video')
      #session[
      post :search, search_word: 'Futu'
      expect(response).to redirect_to new_session_path
    end
  end
end

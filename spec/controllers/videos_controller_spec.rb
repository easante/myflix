require 'spec_helper'

describe VideosController do
  before do
    set_current_user
  end

  describe "GET show" do
    it "assigns the requested video to @video" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq video
    end

    it "assigns a new review to @review" do
      video = Fabricate(:video)
      review = video.reviews.build
      get :show, id: video.id
      expect(assigns(:review)).to be_instance_of(Review)
    end

    it "assigns the list of reviews to @reviews" do
      video = Fabricate(:video)
      review1 = Fabricate(:review)
      review1.created_at = 1.day.ago
      review2 = Fabricate(:review, stars: 5)

      get :show, id: video.id
      expect(Review.count).to eq 2
    end

    it "renders the show template" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to render_template :show
    end
  end

  describe "POST search" do
    it "returns the video that matches the search string" do
      futurama = Fabricate(:video, title: 'Futurama')

      post :search, search_word: 'Futu'
      expect(assigns(:videos)).to eq [futurama]
    end

    it "redirects to the sign in page for unauthenticated user" do
      clear_current_user
      futurama = Video.create(title: 'Futurama', description: 'Cartoon video')

      post :search, search_word: 'Futu'
      expect(response).to redirect_to new_session_path
    end
  end
end

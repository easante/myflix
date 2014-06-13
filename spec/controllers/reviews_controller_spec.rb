require 'spec_helper'

describe ReviewsController do

  describe "POST create" do
    before do
      set_current_user
    end

    context "authenticated users" do
      let(:video) { Fabricate(:video) }

      it "creates a review with valid inputs for authenticated users" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(Review.count).to eq 1
      end
  
      it "fails to create a review with invalid inputs for authenticated users" do
        post :create, review: Fabricate.attributes_for(:review, comment: ""), video_id: video.id
        expect(response).to render_template 'videos/show'
      end

      it "redirects to the video show page" do
        review = Fabricate(:review)
  
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to video_path(video.id)
      end
    end

    context "unauthenticated users" do
      it "fails to create a review for unauthenticated users" do
        clear_current_user
        video = Fabricate(:video)
        user = Fabricate(:user)
        review = Fabricate(:review, video: video, user: user)
  
        post :create, stars: review.stars, comment: review.comment, user_id: review.user_id, video_id: review.user_id
        expect(response).to redirect_to new_session_path
      end
    end
  end
end

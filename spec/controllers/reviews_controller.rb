require 'spec_helper'

describe ReviewsController do

  describe "POST search" do
    it "creates a review with valid inputs for authenticated users" do
      review = Fabricate(:review)
      session[:user_id] = Fabricate(:user).id

      post :create, stars: review.stars, comment: review.comment, user_id: review.user_id, video_id: review.user_id
      expect(review.stars).not_to be_nil
    end

    it "fails to create a review for unauthenticated users" do
      review = Fabricate(:review)

      post :create, stars: review.stars, comment: review.comment, user_id: review.user_id, video_id: review.user_id
      expect(response).to redirect_to :sign_in_path
    end

    it "fails to create a review with invalid inputs for authenticated users" do
      video = Fabricate(:video)
      review = Fabricate(:review)
      session[:user_id] = Fabricate(:user).id

      post :create, stars: review.stars, user_id: review.user_id, video_id: review.user_id
      expect(respose).to redirect_to :video_path(video.id)
    end

    it "redirects to the video show page" do
      review = Fabricate(:review)
      video = Fabricate(:video)
      session[:user_id] = Fabricate(:user).id
      post :create, review
      expect(response).to redirect_to video_path(video.id)
    end
  end
end

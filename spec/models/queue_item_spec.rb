require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) } 
  it { should belong_to(:video) } 

  it { should validate_presence_of(:user_id) } 
  it { should validate_presence_of(:video_id) } 
  it { should validate_numericality_of(:position).only_integer } 

  describe "#video_title" do
    it "should return the title of the associated movie" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.video_title).to eq (video.title)
    end
  end

  describe "#category_name" do
    it "should return the name of the movie category" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.category_name).to eq (video.category.name)
    end
  end

  describe "#category" do
    it "should return the category of the movie" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.category).to eq (queue_item.video.category)
    end
  end

  describe "#star_rating" do
    it "should return the user review" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, stars: 4)
      expect(review.stars).to eq (4)
    end
  end

  describe "#star_rating=" do
    it "should update the star rating if there is a rating" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, stars: 3)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.star_rating = 1

      expect(review.reload.stars).to eq (1)
    end

    it "should create a new review with the star rating if rating does not exist" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.star_rating = 3

      expect(Review.first.stars).to eq (3)
    end

    it "should clear the star rating of a review if rating exists" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      queue_item.star_rating = nil

      expect(Review.first.stars).to be_nil
    end
  end

end

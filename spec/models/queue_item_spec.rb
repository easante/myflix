require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) } 
  it { should belong_to(:video) } 

  it { should validate_presence_of(:position) } 
  it { should validate_presence_of(:user_id) } 
  it { should validate_presence_of(:video_id) } 

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
end

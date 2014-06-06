require 'spec_helper'

describe Review do
  subject { Fabricate(:review) }
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:comment) }
  it { should ensure_inclusion_of(:stars).in_range(1..5).with_message('stars must be between 1 and 5') }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:user_id) }

  it "should save a new review" do
    review = Fabricate(:review)
    expect(review.stars).to eq 3
  end
end

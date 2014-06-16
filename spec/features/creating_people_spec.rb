require 'spec_helper'

feature 'Creating people page' do
  let(:john)  { Fabricate(:user) }
  let(:mary)  { Fabricate(:user) }
  let(:dan)  { Fabricate(:user) }
  let!(:category) { Fabricate(:category) }
  let!(:video1) { Fabricate(:video, category: category) }
  let!(:video2) { Fabricate(:video, category: category) }
  let!(:queue1) { Fabricate(:queue_item, user: mary, video:video1) }
  let!(:queue2) { Fabricate(:queue_item, user: dan, video: video2) }
  let!(:review1) { Fabricate(:review, user: mary, video: video1, stars: 3, comment: "True") }
  let!(:review2) { Fabricate(:review, user: dan, video: video2, stars: 4, comment: "False") }
  let!(:friendship) { Fabricate(:friendship, user_id: john.id, friend_id: mary.id) }

  before do
    sign_in_as!(john)
  end

  scenario "successful profile" do
 
    find("a[href='/videos/#{video1.id}']").click
    click_link mary.full_name
 
    expect(current_url).to eq(user_url(mary.id))
 
    click_link "Follow"
    expect(current_url).to eq(people_url)
    expect(page).to have_content('People I Follow')
    expect(page).to have_content('Videos in Queue')
    expect(page).to have_content('Followers')
    expect(page).to have_content('Unfollow')
    expect(page).to have_content(mary.full_name)
    expect(page).to have_link(mary.full_name)
    expect(page).to have_content(mary.queue_items.count)
    expect(page).to have_content(mary.inverse_friends.count)
    expect(page).to have_css("a[href='/friendships/#{friendship.id}']")
  end 
end 

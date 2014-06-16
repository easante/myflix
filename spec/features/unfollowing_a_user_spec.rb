require 'spec_helper'

feature 'Unfollowing a user' do
  let(:john)  { Fabricate(:user) }
  let(:mary)  { Fabricate(:user) }
  let!(:friendship) { Fabricate(:friendship, user_id: john.id, friend_id: mary.id) }

  before do
    sign_in_as!(john)
  end

  scenario "successful unfollow" do
 
    click_link "People"
    find("a[href='/friendships/#{friendship.id}']").click
 
    expect(current_url).to eq(people_url)
    expect(page).to have_content("#{mary.full_name} unfollowed.")
  end 
end 

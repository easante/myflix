require 'spec_helper'

feature 'Showing User profile page' do
  let(:john)  { Fabricate(:user) }
  let(:mary)  { Fabricate(:user) }
  let!(:category1) { Fabricate(:category) }
  let!(:category2) { Fabricate(:category) }
  let!(:video1) { Fabricate(:video, category: category2) }
  let!(:video2) { Fabricate(:video, category:category1) }
  let!(:queue1) { Fabricate(:queue_item, user: john, video:video1) }
  let!(:queue2) { Fabricate(:queue_item, user: john, video: video2) }
  let!(:review1) { Fabricate(:review, user: john, video: video1) }
  let!(:review2) { Fabricate(:review, user: john, video: video2) }

  before do
    sign_in_as!(john)
  end

  scenario "successful profile" do
 
    user_video_collection_text  = "#{john.full_name}'s video collections (#{john.queue_items.count})"
    user_review_collection_text  = "#{john.full_name}'s Reviews (#{john.reviews.count})"
 
 print page.html
    find("a[href='/videos/#{video1.id}']").click
    click_link john.full_name
 
    expect(current_url).to eq(user_url(john.id))
    expect(john.queue_items.count).to eq(2)
    within('h2') do
      expect(page).to have_content(user_video_collection_text)
    end
 
    within('thead tr') do
      expect(page).to have_content('Video Title')
      expect(page).to have_content('Genre')
    end
 
    expect(page).to have_link(video1.title)
    expect(page).to have_link(video1.category.name)
    expect(page).to have_link(video2.title)
    expect(page).to have_link(video2.category.name)
 
    within('header h3') do
      expect(page).to have_content(user_review_collection_text)
    end
 
    expect(page).to have_content("#{review1.comment}")
    expect(page).to have_content("Rating: #{review1.stars} / 5")
  end
end 

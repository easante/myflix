require 'spec_helper'

feature 'Adding videos to the queue' do
  let(:user) { Fabricate(:user) }
  let!(:category1) { Fabricate(:category) }
  let!(:category2) { Fabricate(:category) }
  let!(:video1) { Fabricate(:video, category: category2) }
  let!(:video2) { Fabricate(:video, category:category1) }

  before do
    visit root_path
 
    click_link "Sign In"
    fill_in  "Email Address", with: user.email
    fill_in  "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content('Sign in successful.')
  end

  scenario "add videos to queue" do
    find(:xpath, "//a[contains(@href, '/videos/1')]").click
    click_link "+ My Queue"

    expect(current_url).to eq(queue_items_url)
    expect(page).to have_content(video1.title)
 
    click_link video1.title
    expect(current_url).to eq(video_url(video1))
    expect(page).to have_content(video1.title)
    expect(page).not_to have_content('+ My Queue')

    visit home_path
    click_link 'Videos'
    find(:xpath, "//a[contains(@href, '/videos/2')]").click
    click_link "+ My Queue"

    click_link 'My Queue'
    print page.body
    expect(find("input[data-video-id='1']").value).to eq('1')
    expect(find("input[data-video-id='2']").value).to eq('2')

    find("input[data-video-id='1']").set(2)
    find("input[data-video-id='2']").set(1)
    click_button 'Update Instant Queue'

    expect(find("input[data-video-id='1']").value).to eq('2')
    expect(find("input[data-video-id='2']").value).to eq('1')
  end
end 

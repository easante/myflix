require 'spec_helper'

feature 'Adding new videos' do
  let(:admin) { Fabricate(:user, admin: true) }
  let!(:category1) { Fabricate(:category) }
#  let!(:category2) { Fabricate(:category) }
#  let!(:video1) { Fabricate(:video, category: category2) }
#  let!(:video2) { Fabricate(:video, category:category1) }

  before do
    visit root_path
 
    click_link "Sign In"
    fill_in  "Email Address", with: admin.email
    fill_in  "Password", with: admin.password
    click_button "Sign in"

    expect(page).to have_content('Sign in successful.')
  end

  scenario "add a video" do
    visit admin_add_video_path
    expect(page).to have_content('Add a New Video')

    fill_in 'Title', with: 'City of Angels'
    select category1.name, from: Category
    fill_in 'Description', with: 'Angels that lived in a city'
    attach_file 'Large cover', 'public/tmp/monk_large.jpg'
    attach_file 'Small cover', 'public/tmp/monk.jpg'
    fill_in 'Video url', with: 'https://diikjwpmj92eg.cloudfront.net/uploads/week6/HW3%20watch%20video.mp4'
    click_button 'Add Video'

    expect(Video.all.count).to eq(1)
    expect(current_path).to eq(admin_add_video_path)
  end
end 

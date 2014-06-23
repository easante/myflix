require 'spec_helper'

#feature 'Adding new videos' do
#  let(:admin) { Fabricate(:user, admin: true) }
##  let!(:category1) { Fabricate(:category) }
##  let!(:category2) { Fabricate(:category) }
##  let!(:video1) { Fabricate(:video, category: category2) }
##  let!(:video2) { Fabricate(:video, category:category1) }
#
#  before do
#    visit root_path
# 
#    click_link "Sign In"
#    fill_in  "Email Address", with: admin.email
#    fill_in  "Password", with: admin.password
#    click_button "Sign in"
#
#    expect(page).to have_content('Sign in successful.')
#    expect(current_url).to eq(root_url)
#  end
#
#  scenario "add a video" do
#    visit admin_add_video_path
#    expect(page).to have_content('Add a New Video')
#
#    fill_in 'Title', with: 'City of Angels'
#
#    click_button 'Add Video'
#  end
end 

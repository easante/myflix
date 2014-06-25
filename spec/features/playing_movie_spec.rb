require 'spec_helper'

feature 'Adding new videos' do
  let(:admin) { Fabricate(:user, admin: true) }
  let(:user) { Fabricate(:user) }
  let!(:category) { Fabricate(:category) }

  before do
    visit root_path
  end

  scenario "add a video" do
    sign_in_as!(admin)
    visit admin_add_video_path
    fill_in 'Title', with: 'City of Angels'
    select category.name, from: Category
    fill_in 'Description', with: 'Angels that lived in a city'
    attach_file 'Large cover', 'spec/support/uploads/monk_large.jpg'
    attach_file 'Small cover', 'spec/support/uploads/monk.jpg'
    fill_in 'Video url', with: 'http://www.example.com/video.mp4'
    click_button 'Add Video'

    visit sign_out_path
    sign_in_as!(user)
    find("a[href='/videos/#{Video.first.id}']").click

    expect(page).to have_selector("img[src='/tmp/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/video.mp4']")
  end
end 

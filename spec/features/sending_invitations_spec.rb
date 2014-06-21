require 'spec_helper'

feature 'Sending invitation to a friend' do
  let(:john)  { Fabricate(:user) }
  let(:mary)  { Fabricate(:user) }
  let!(:friendship) { Fabricate(:friendship, user_id: john.id, friend_id: mary.id) }

  before do
    sign_in_as!(john)
  end

  scenario "successfully sending invitation" do
 
    visit invite_friend_path
    fill_in "Friend's Name", with: "Mike Clarke"
    fill_in "Friend's Email Address", with: "mike@example.com"
    fill_in "Invitation Message", with: "Mike Clarke please join my site!"
    click_button "Send Invitation"

    expect(current_path).to eq(home_path)
    open_email("mike@example.com")
    current_email.click_link("Register to use the service")
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Mike Clarke"
    click_button "Sign Up"

    expect(page).to have_content('Sign in')
    expect(current_path).to eq sign_in_path
  end 
end 

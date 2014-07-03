require 'spec_helper'

feature 'Sending invitation to a friend' do
  let(:john)  { Fabricate(:user) }
  let(:mary)  { Fabricate(:user) }
  let!(:friendship) { Fabricate(:friendship, user_id: john.id, friend_id: mary.id) }

  before do
    sign_in_as!(john)
  end

  scenario "successfully sending invitation", js: true do

    visit invite_friend_path
    fill_in "Friend's Name", with: "Mike Clarke"
    fill_in "Friend's Email Address", with: "mike@example.com"
    fill_in "Invitation Message", with: "Mike Clarke please join my site!"
    click_button "Send Invitation"

    expect(current_path).to eq(home_path)
    open_email("mike@example.com")
    current_email.click_link("Register to use the service")
    print page.body
    save_and_open_page

    fill_in "Email Address", with: "mike@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Mike Clarke"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select '10 - October', from: "date_month"
    select '2016', from: "date_year"
    click_button "Sign Up"

    expect(page).to have_content('Sign in')
    expect(current_path).to eq sign_in_path
  end
end

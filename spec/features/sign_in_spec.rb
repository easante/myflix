require 'spec_helper'

feature 'User Sign in' do
  let(:user) { Fabricate(:user) }

  scenario "successful sign in" do
   visit root_path

   click_link "Sign In"
   fill_in  "Email Address", with: user.email
   fill_in  "Password", with: user.password
   click_button "Sign in"

   expect(current_url).to eq(home_url)
   expect(page).to have_content('Sign in successful.')
  end

  scenario "unsuccessful sign in" do
   visit root_path

   click_link "Sign In"
   fill_in  "Email Address", with: ""
   fill_in  "Password", with: user.password
   click_button "Sign in"

   expect(current_url).to eq(sign_in_url)
   expect(page).to have_content('Invalid email/password combination.')
  end
end 

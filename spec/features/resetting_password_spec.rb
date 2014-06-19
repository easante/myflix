require 'spec_helper'

feature 'Resetting password' do
  let(:john)  { Fabricate(:user) }

  scenario "successful password reset" do
 
    visit root_path
    click_link "Sign In"
    click_link "Forgotten Password?"
    fill_in "Email Address", with: john.email
    click_button "Reset Password"
 
    expect(page).to have_content('We have sent an email with instruction to reset your password.')
  end 
end 

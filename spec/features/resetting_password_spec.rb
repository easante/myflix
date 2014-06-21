require 'spec_helper'

feature 'Resetting password' do
  let(:john)  { Fabricate(:user, password: 'password') }

  before do
    clear_emails
  end

  scenario "successful password reset" do
 
    visit root_path
    click_link "Sign In"
    click_link "Forgotten Password?"
    fill_in "Email Address", with: john.email
    click_button "Reset Password"
 
    expect(page).to have_content('We have sent an email with instruction to reset your password.')
    open_email(john.email)

    current_email.click_link("Reset password")
    fill_in "New Password", with: "password2"
    click_button "Reset Password"
    expect(page).to have_content('Sign in')
    expect(current_path).to eq sign_in_path

    fill_in "Email Address", with: john.email
    fill_in "Password", with: "password2"
    click_button "Sign in"
    
    expect(page).to have_content('Welcome')
    expect(current_path).to eq home_path
  end 
end 

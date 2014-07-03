require 'spec_helper'

feature 'Signing up' do

  scenario "successfully sign up", js: true do
    visit root_path
    click_link "Sign Up"
    fill_in_user_info("mike@example.com", "password", "Mike Clarke")

    fill_in_credit_card_info "4242424242424242"
    click_button "Sign Up"

    expect(page).to have_content('Sign in')
    expect(current_path).to eq sign_in_path
  end

  scenario "with no email address", js: true do
    visit root_path
    click_link "Sign Up"
    fill_in_user_info("", "password", "Mike Clarke")

    fill_in_credit_card_info "4242424242424242"
    click_button "Sign Up"

    expect(page).to have_content("Email Address can't be blank")
    expect(page).to have_content("Invalid user information.")
  end

  scenario "with no full name", js: true do
    visit root_path
    click_link "Sign Up"
    fill_in_user_info("mike@example.com", "password", "")

    fill_in_credit_card_info "4242424242424242"
    click_button "Sign Up"

    expect(page).to have_content("Full Name can't be blank")
    expect(page).to have_content("Invalid user information.")
  end

  scenario "with a declined credit card", js: true do
    visit root_path
    click_link "Sign Up"
    fill_in_user_info("mike@example.com", "password", "Mike Clarke")

    fill_in_credit_card_info "4000000000000002"
    click_button "Sign Up"

    expect(page).to have_content("Your card was declined")
#    expect(page).to have_content("Sign up unsuccessful.")
  end

  scenario "with incorrect credit card number", js: true do
    visit root_path
    click_link "Sign Up"
    fill_in_user_info("mike@example.com", "password", "Mike Clarke")

    fill_in_credit_card_info "4242424242424241"
    click_button "Sign Up"

    expect(page).to have_content("Your card number is incorrect.")
  end

end

def fill_in_user_info(email, password, full_name)
  fill_in "Email Address", with: email
  fill_in "Password", with: password
  fill_in "Full Name", with: full_name
end

def fill_in_credit_card_info(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "123"
  select '10 - October', from: "date_month"
  select '2016', from: "date_year"
end

require 'spec_helper'

feature 'Admin viewing payments' do
  let(:admin) { Fabricate(:admin) }
  let!(:john) { Fabricate(:user, full_name: 'John Bull') }
  let!(:john_payment) { Fabricate(:payment, user: john) }

  scenario 'does not show list of successful payments to non-admins' do
    sign_in_as!(john)
    visit 'admin_views_payments'
    expect(page).to have_content("You have to be an admin to do that.")
    expect(page.current_path).to eq(home_path)
  end

  scenario 'shows list of successful payments to admins only' do
    sign_in_as!(admin)
    visit 'admin_views_payments'
    expect(page).to have_content(john.full_name)
    expect(page).to have_content(john.email)
    expect(page).to have_content(john_payment.amount)
    expect(page).to have_content(john_payment.reference_id)
  end


end

require "rails_helper"
require "axe-rspec"

RSpec.feature "Test authentication accessibility", driver: :headless_firefox, accessibility: true do
  scenario "sign in page" do
    visit sign_in_path

    expect(page).to have_content("Sign in")
    expect(page).to be_axe_clean
  end

  scenario "sign out page" do
    visit sign_out_path

    expect(page).to have_content("You have signed out")
    expect(page).to be_axe_clean
  end

  scenario "authentication failed page" do
    visit auth_failure_path

    expect(page).to have_content("Authentication failed.")
    expect(page).to be_axe_clean
  end
end

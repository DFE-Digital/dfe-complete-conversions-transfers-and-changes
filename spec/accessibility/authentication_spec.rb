require "rails_helper"
require "axe-rspec"

RSpec.feature "Test authentication accessibility", driver: :headless_firefox, accessibility: true do
  scenario "sign in page" do
    visit sign_in_path

    expect(page).to have_content("Sign in")
    check_accessibility(page)
  end

  scenario "sign out page" do
    visit sign_out_path

    expect(page).to have_content("You have signed out")
    check_accessibility(page)
  end

  scenario "authentication failed page" do
    visit auth_failure_path

    expect(page).to have_content("Authentication failed.")
    check_accessibility(page)
  end
end

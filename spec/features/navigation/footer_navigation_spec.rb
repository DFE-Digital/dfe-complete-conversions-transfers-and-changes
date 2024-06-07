require "rails_helper"

RSpec.feature "Footer navigation" do
  scenario "users can see the footer links" do
    visit root_path

    expect(page).to have_link("Privacy notice")
    expect(page).to have_link("Accessibility Statement")
    expect(page).to have_link("Cookies")
    expect(page).to have_link("How to use this system (opens in a new tab)")
    expect(page).to have_link("Email Service Support for help with using this system")
  end
end

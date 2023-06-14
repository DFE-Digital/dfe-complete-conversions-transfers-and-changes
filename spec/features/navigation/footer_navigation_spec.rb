require "rails_helper"

RSpec.feature "Footer navigation" do
  scenario "users can see the footer links" do
    visit root_path

    expect(page).to have_link("Privacy notice")
    expect(page).to have_link("Accessibility Statement")
    expect(page).to have_link("Cookies")
    expect(page).to have_link("How to use this service")
    expect(page).to have_link("Email support")
  end
end

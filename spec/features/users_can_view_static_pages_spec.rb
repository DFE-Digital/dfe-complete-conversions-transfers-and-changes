require "rails_helper"

RSpec.feature "Users can view static pages" do
  scenario "can see the privacy notice" do
    visit page_path(id: "privacy")

    expect(page).to have_current_path("/privacy")
    expect(page).to have_content("Privacy Notice") # This string appears all over the site in the footer, so also test:
    expect(page).to have_content("When we collect personal information")
  end
end

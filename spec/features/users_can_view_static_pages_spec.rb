require "rails_helper"

RSpec.feature "Users can view static pages" do
  scenario "can see the privacy notice" do
    visit page_path(id: "privacy")

    expect(page).to have_current_path("/privacy")
    expect(page).to have_content("Privacy Notice") # This string appears all over the site in the footer, so also test:
    expect(page).to have_content("When we collect personal information")
  end

  scenario "can see the accessibility page" do
    visit page_path(id: "accessibility")

    expect(page).to have_current_path("/accessibility")
    expect(page).to have_content("Accessibility statement") # This string appears all over the site in the footer, so also test:
    expect(page).to have_content("This accessibility statement applies to Complete conversions, transfers and changes.")
  end

  scenario "can see the `404 page not found` error page" do
    visit page_path(id: "page_not_found")

    expect(page).to have_current_path("/page_not_found")
    expect(page).to have_content("Page not found")
  end

  scenario "can see the `500 server error` error page" do
    visit page_path(id: "internal_server_error")

    expect(page).to have_current_path("/internal_server_error")
    expect(page).to have_content("Sorry, there is a problem with the service")
  end

  scenario "can see the `API timeout` error page" do
    visit page_path(id: "academies_api_client_timeout")

    expect(page).to have_current_path("/academies_api_client_timeout")
    expect(page).to have_content("Sorry, the Academies API timed out")
  end

  scenario "can see the `API unauthorised` error page" do
    visit page_path(id: "academies_api_client_unauthorised")

    expect(page).to have_current_path("/academies_api_client_unauthorised")
    expect(page).to have_content("Sorry, there was a problem")
  end
end

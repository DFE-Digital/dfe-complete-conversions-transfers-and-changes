require "rails_helper"

RSpec.feature "Footer navigation" do
  scenario "users can see the footer links" do
    visit root_path

    expect(page).to have_link("Privacy notice")
    expect(page).to have_link("Accessibility Statement")
    expect(page).to have_link("Cookies")

    expect(page).to have_link("Get help with a Regions Group system (opens in a new tab)",
      href: "https://forms.office.com/Pages/ResponsePage.aspx?id=yXfS-grGoU2187O4s0qC-X7F89QcWu5CjlJXwF0TVktUMTFEUVRCVVg4WlMyS1AzUEJSUDAySlhQTCQlQCN0PWcu")

    expect(page).to have_link("How to use this system (opens in a new tab)",
      href: "https://educationgovuk.sharepoint.com/sites/lvewp00299/SitePages/complete-conversions-transfers-and-changes.aspx")

    expect(page).to have_link("Give feedback about a Regions Group system (opens in a new tab)",
      href: "https://forms.office.com/Pages/ResponsePage.aspx?id=yXfS-grGoU2187O4s0qC-SZtRygfwTNOqcfRq-MXpv9UOTIyQlNYR0hJT1Q0TUFVSlJGVFhES01LVC4u")

    expect(page).to have_link("Suggest a change to a Regions Group system (opens in a new tab)",
      href: "https://forms.office.com/Pages/ResponsePage.aspx?id=yXfS-grGoU2187O4s0qC-fkHK2JGo_BIpVChpLMaBFpUNUFDSzhQN0FHVklTV0JWTzFZTjNKWTNJUi4u")
  end
end

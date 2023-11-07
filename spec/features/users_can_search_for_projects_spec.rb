require "rails_helper"

RSpec.feature "Users can search for projects" do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_successful_api_responses(urn: 100001, ukprn: 10061021)
    create(:conversion_project, caseworker: user, urn: 100001)
    sign_in_with_user(user)
  end

  scenario "Users can enter a search term in a search box in the header" do
    visit root_path

    expect(page).to have_content("Search this website")

    fill_in "searchterm", with: "100001"
    click_on(class: "dfe-search__submit")

    expect(page).to have_content("Search results for \"100001\"")
    expect(page).to have_content("1 result found")
  end
end

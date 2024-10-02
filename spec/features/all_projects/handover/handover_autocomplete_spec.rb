require "rails_helper"

RSpec.feature "Handover with autocomplete", driver: :headless_firefox do
  before do
    user = create(:regional_delivery_officer_user)
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  after do
    sign_out
    # we need to wait after signing out otherwise we get flaking sessions
    sleep(0.4)
  end

  scenario "can handover to regional teams" do
    create(
      :regional_delivery_officer_user,
      first_name: "Test",
      last_name: "User",
      email: "test.user@education.gov.uk",
      team: :north_west
    )
    project = create(:conversion_project, :inactive)

    visit new_all_handover_projects_path(project)

    within "#assigned-to-regional-caseworker-team" do
      choose "No"
    end
    fill_in "Handover comments", with: "Test handover comments.\n\nThese are the handover comments for tests."
    fill_in "School SharePoint link", with: "https://educationgovuk.sharepoint.com/establishment"
    fill_in "Incoming trust SharePoint link", with: "https://educationgovuk.sharepoint.com/incoming-trust"
    within "#two-requires-improvement" do
      choose "No"
    end
    click_button "Confirm"

    choose "North West"
    fill_in "Who will complete this project?", with: "test.user@education.gov.uk"

    sleep(0.5) # give it time to render the autocomplete!

    within("ul.autocomplete__menu") do
      expect(page).to have_content("Test User (test.user@education.gov.uk)")
      find("li.autocomplete__option").click
    end
    click_button "Confirm"

    expect(page).to have_content("Project assigned")
  end
end

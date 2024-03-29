require "rails_helper"
require "axe-rspec"

RSpec.feature "Test project information accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "project information page" do
    visit project_information_path(project)

    expect(page).to have_content("Project details")
    check_accessibility(page)
  end
end

require "rails_helper"
require "axe-rspec"

RSpec.feature "Test project information accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:project) { create(:project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "project information page" do
    visit project_information_path(project)

    expect(page).to have_content("Project details")
    expect(page).to be_axe_clean
  end
end

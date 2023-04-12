require "rails_helper"

RSpec.feature "Statistics page" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_successful_api_response_to_create_any_project
    mock_pre_fetched_api_responses_for_any_establishment_and_trust
  end

  scenario "users can view the statistics page" do
    visit all_statistics_projects_path

    expect(page).to have_content("Statistics Page")
  end
end

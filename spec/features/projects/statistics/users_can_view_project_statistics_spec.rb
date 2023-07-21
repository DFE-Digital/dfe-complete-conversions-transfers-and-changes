require "rails_helper"

RSpec.feature "Statistics page" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "users can view the statistics page" do
    visit all_statistics_projects_path

    expect(page).to have_content("Statistics")
  end
end

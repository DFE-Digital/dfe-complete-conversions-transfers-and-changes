require "rails_helper"

RSpec.feature "Users in regional teams can view handed over projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, team: "london") }

  context "when no projects have been handed over to the regional casework services team" do
    scenario "they see an empty message" do
      create(:conversion_project, urn: "123456", region: "london", team: "london")
      create(:conversion_project, urn: "654321", region: "london", team: "london")

      visit handed_over_team_projects_path

      expect(page).to have_content("There are no handed over projects")
    end
  end

  context "when projects have been handed over to the regional casework services team" do
    scenario "a user of the regional team can see their handed over projects listed on the handed over page" do
      handed_over_london_project = create(:conversion_project, urn: "123456", region: "london", team: "regional_casework_services")
      handed_over_london_project_two = create(:conversion_project, urn: "654321", region: "london", team: "regional_casework_services")
      london_project = create(:conversion_project, urn: "987654", region: "london", team: "london")

      visit handed_over_team_projects_path

      expect(page).to have_content(handed_over_london_project.urn)
      expect(page).to have_content(handed_over_london_project_two.urn)
      expect(page).not_to have_content(london_project.urn)
    end
  end
end

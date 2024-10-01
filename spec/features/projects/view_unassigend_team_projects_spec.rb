require "rails_helper"

RSpec.feature "Viewing unassigned team projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "as a regional casework services lead" do
    let(:user) { create(:user, :team_leader) }

    scenario "they can view all unassigned projects in the team, except for inactive projects" do
      matching_project = create(:conversion_project, assigned_to: nil, team: "regional_casework_services")
      inactive_project = create(:conversion_project, :inactive, urn: 156843, team: "regional_casework_services")

      visit unassigned_team_projects_path

      expect(page).to have_content(matching_project.urn)
      expect(page).to have_content(matching_project.establishment.region_name)
      expect(page).not_to have_content(inactive_project.urn)
    end
  end
end

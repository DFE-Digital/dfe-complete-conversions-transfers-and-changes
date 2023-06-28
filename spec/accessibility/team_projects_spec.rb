require "rails_helper"
require "axe-rspec"

RSpec.feature "Team projects", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :team_leader) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "> In progress" do
    project = create(:conversion_project, assigned_to: user, team: "regional_casework_services", urn: 123456)

    visit in_progress_team_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("In progress")
    check_accessibility(page)
  end

  scenario "> Completed" do
    project = create(:conversion_project, assigned_to: user, completed_at: Date.yesterday, team: "regional_casework_services", urn: 123434)

    visit completed_team_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("Completed")
    check_accessibility(page)
  end

  scenario "> Unassigned" do
    create(:conversion_project, assigned_to: nil, urn: 123434, team: "regional_casework_services")

    visit unassigned_team_projects_path

    expect(page).to have_link("Unassigned")
    check_accessibility(page)
  end
end

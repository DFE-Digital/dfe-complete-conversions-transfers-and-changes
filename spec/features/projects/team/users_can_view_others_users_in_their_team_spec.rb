require "rails_helper"

RSpec.feature "Users can view the other users in their team" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, :caseworker, team: "regional_casework_services") }

  scenario "they don't see users from other teams" do
    other_user = create(:user, :regional_delivery_officer, team: "london")

    visit users_team_projects_path

    expect(page).to_not have_content(other_user.full_name)
  end

  scenario "they can navigate to a by_user page and see projects assigned to another user in the same team" do
    other_user = create(:user, :caseworker, first_name: "Amy", team: "regional_casework_services")
    project = create(:conversion_project, assigned_to: other_user)

    visit users_team_projects_path
    expect(page).to have_content(other_user.full_name)
    click_on "View projects for #{other_user.full_name}"
    expect(page).to have_content("Projects assigned to #{other_user.full_name}")
    expect(page).to have_content(project.establishment.name)
  end
end

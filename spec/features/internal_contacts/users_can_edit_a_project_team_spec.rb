require "rails_helper"

RSpec.feature "Any user can assign a team to a project" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, :caseworker) }

  scenario "assigning a project to a regional team" do
    project = create(:conversion_project, team: "regional_casework_services")
    visit project_path(project)
    click_on "Internal contacts"

    within("#projectInternalContacts") do
      click_on "Change assigned to team"
    end

    choose "London"
    click_on "Continue"

    expect(page).to have_content("Project has been assigned to team successfully")
    expect(project.reload.team).to eql "london"
  end

  scenario "assigning a project to regional casework services" do
    project = create(:conversion_project, team: "south_west")
    visit project_path(project)
    click_on "Internal contacts"

    within("#projectInternalContacts") do
      click_on "Change assigned to team"
    end

    choose "Regional casework services"
    click_on "Continue"

    expect(page).to have_content("Project has been assigned to team successfully")
    expect(project.reload.team).to eql "regional_casework_services"
  end
end

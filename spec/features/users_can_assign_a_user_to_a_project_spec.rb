require "rails_helper"

RSpec.feature "Any user can assign any other user to a project" do
  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  let!(:project) { create(:conversion_project, team: "regional_casework_services", assigned_to: nil) }
  let!(:another_user) { create(:user, :caseworker, first_name: "Another", last_name: "User") }

  context "when the user is a regional caseworker" do
    let(:user) { create(:user, :caseworker) }

    scenario "they can assign a user from the internal contacts tab" do
      assign_user_from_internal_contacts
    end

    scenario "they can NOT assign a user from the unassigned projects view" do
      cannot_assign_user_from_unassigned_projects
    end
  end

  context "when the user is a regional caseworker services team lead" do
    let(:user) { create(:user, :team_leader) }

    scenario "they can assign a user from the internal contacts tab" do
      assign_user_from_internal_contacts
    end

    scenario "they can assign a user from the unassigned projects view" do
      assign_user_from_unassigned_projects
    end
  end

  context "when the user is a regional delivery officer" do
    let(:user) { create(:user, :regional_delivery_officer) }

    scenario "they can assign a user from the internal contacts tab" do
      assign_user_from_internal_contacts
    end

    scenario "they can NOT assign a user from the unassigned projects view" do
      cannot_assign_user_from_unassigned_projects
    end
  end

  def assign_user_from_internal_contacts
    visit project_path(project)
    click_on "Internal contacts"

    within("#projectInternalContacts div:first-of-type") do
      click_on "Change"
    end

    fill_in "Email of person", with: another_user.email
    click_on "Continue"

    expect(page).to have_content("Project has been assigned successfully")
    expect(project.reload.assigned_to).to eql another_user
  end

  def assign_user_from_unassigned_projects
    visit unassigned_team_projects_path
    expect(page).to have_content(project.urn)
    click_on "Assign #{project.establishment.name} project"

    fill_in "Email of person", with: another_user.email
    click_on "Continue"

    expect(page).to have_content("Project has been assigned successfully")
    expect(page).to have_current_path(unassigned_team_projects_path)
    expect(project.reload.assigned_to).to eql another_user
  end

  def cannot_assign_user_from_unassigned_projects
    visit unassigned_team_projects_path
    expect(page).to have_content(I18n.t("unauthorised_action.message"))
  end
end

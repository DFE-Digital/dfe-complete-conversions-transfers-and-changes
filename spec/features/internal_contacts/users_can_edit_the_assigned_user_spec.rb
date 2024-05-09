require "rails_helper"

RSpec.feature "Users change the assigned user" do
  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  context "when they are a caseworker" do
    let(:user) { create(:user, :caseworker) }

    scenario "by navigating to a project" do
      project = create(:conversion_project, assigned_to: user)
      other_user = create(:user, :caseworker, email: "other.user@education.gov.uk")

      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end
      fill_in "Email of person", with: other_user.email
      click_button "Continue"

      expect(page).to have_content("Project has been assigned successfully")
      expect(page).to have_content("Not assigned to project")
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        expect(page).to have_content(other_user.first_name)
      end
    end
  end

  context "when they are a team leader" do
    let(:user) { create(:user, :team_leader) }

    scenario "by navigating to a project" do
      project = create(:conversion_project, assigned_to: user)
      other_user = create(:user, :caseworker, email: "other.user@education.gov.uk")

      visit project_path(project)
      click_on "Internal contacts"
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        click_on "Change"
      end
      fill_in "Email of person", with: other_user.email
      click_button "Continue"

      expect(page).to have_content("Project has been assigned successfully")
      expect(page).to have_content("Not assigned to project")
      within("#projectInternalContacts dl.govuk-summary-list div:first-of-type") do
        expect(page).to have_content(other_user.first_name)
      end
    end

    scenario "from the unassigned view" do
      create(:conversion_project, assigned_to: nil, team: user.team)
      other_user = create(:user, :caseworker, email: "other.user@education.gov.uk")

      visit root_path
      click_on "Your team projects"
      click_on "Unassigned"
      click_on "Assign"
      fill_in "Email of person", with: other_user.email
      click_button "Continue"

      expect(page).to have_content("Project has been assigned successfully")
      expect(page).to have_content("There are no unassigned projects.")
    end
  end
end

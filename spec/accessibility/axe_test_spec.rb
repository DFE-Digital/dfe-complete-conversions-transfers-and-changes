require "rails_helper"
require "axe-rspec"

RSpec.feature "Run axe accessibility tool", driver: :headless_firefox, accessibility: true do

  context "when the user is a caseworker" do
    let(:user) { create(:user, email: "user1@education.gov.uk") }
    let(:project) { create(:project, caseworker: user) }
    let(:action) { create(:action) }
    let(:task_id) { action.task.id }
    let(:project_id) { action.task.section.project.id }

    before do
      mock_successful_api_responses(urn: 123456, ukprn: 10061021)
      sign_in_with_user(user)
    end

    scenario "test the root page" do
      visit root_path

      expect(page).to be_axe_clean
    end

    scenario "test the sign in page" do
      visit sign_in_path

      expect(page).to be_axe_clean
    end

    scenario "test the sign out page" do
      visit sign_out_path

      expect(page).to be_axe_clean
    end

    scenario "test the authentication failed page" do
      visit auth_failure_path

      expect(page).to be_axe_clean
    end

    scenario "test completed projects page" do
      visit completed_projects_path

      expect(page).to be_axe_clean
    end

    scenario "test a new projects page" do
      visit new_project_path

      expect(page).to be_axe_clean
    end

    scenario "test an existing projects page" do
      visit project_path(project)

      expect(page).to be_axe_clean
    end

    scenario "test an individual task page" do
      visit project_task_path(project_id, task_id)

      expect(page).to be_axe_clean
    end

    scenario "test the task level notes page" do
      visit new_project_note_path(project, task_id: task_id)

      expect(page).to be_axe_clean
    end

    scenario "test project information page" do
      visit project_information_path(project_id)

      expect(page).to be_axe_clean
    end

    scenario "test project notes page" do
      visit project_notes_path(project_id)

      expect(page).to be_axe_clean
    end

    scenario "test project notes edit page" do
      visit project_notes_path(project_id)
       # needs a note added - check users_can_create_and_view_and_delete_notes_spec.rb
      click_link "Edit"

      expect(page).to be_axe_clean
    end

    scenario "test project notes deleted page" do
      visit project_notes_path(project_id)
      # needs a note added - check users_can_create_and_view_and_delete_notes_spec.rb
      click_link("Edit")

      click_button("Delete")

      expect(page).to be_axe_clean
    end

    scenario "test project contacts page" do
      visit project_contacts_path(project_id)

      expect(page).to be_axe_clean
    end

    scenario "test project completed page" do
      visit project_path(project)

      click_on I18n.t("project.complete.submit_button")

      expect(page).to be_axe_clean
    end
  end

  context "when the user is a team leader" do
    let!(:team_leader) { create(:user, team_leader: true) }
    let(:project) { create(:project, team_leader: user) }
    let(:user) { create(:user, :team_leader) }
    let(:project_id) { project.id }

    before do
      mock_successful_api_responses(urn: 123456, ukprn: 10061021)
      sign_in_with_user(user)
    end

    scenario "test change team lead for project page" do
      visit project_assign_team_lead_path(project_id)

      expect(page).to be_axe_clean
    end

    scenario "test change caseworker for project page" do
      visit project_assign_caseworker_path(project_id)

      expect(page).to be_axe_clean
    end

    scenario "test change regional delivery officer for project page" do
      visit project_assign_regional_delivery_officer_path(project_id)

      expect(page).to be_axe_clean
    end
  end


  # context "when the user is a regional delivery officer" do
  # end
end



# regional_delivery_officer - can see everything

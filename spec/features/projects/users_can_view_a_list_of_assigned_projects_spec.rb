require "rails_helper"

RSpec.feature "Viewing assigned projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let!(:other_user) { create(:user, :caseworker, email: "other.user@education.gov.uk") }

  let!(:completed_other_user_project) { create(:conversion_project, urn: 126041, assigned_to: other_user, completed_at: Date.yesterday) }
  let!(:in_progress_other_user_project) { create(:conversion_project, urn: 121813, assigned_to: other_user) }

  let!(:completed_unassigned_project) { create(:conversion_project, urn: 121583, assigned_to: nil, completed_at: Date.yesterday) }
  let!(:in_progress_unassigned_project) { create(:conversion_project, urn: 115652, assigned_to: nil) }

  context "when there are no projects" do
    let(:user) { create(:regional_casework_services_user) }

    scenario "they can view a helpful message" do
      visit in_progress_your_projects_path

      expect(page).to have_content(I18n.t("project.index.empty"))

      visit completed_your_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))
    end
  end

  context "when there are projects" do
    let!(:in_progress_assigned_project) { create(:conversion_project, assigned_to: user, conversion_date: (Date.today + 1.month).at_beginning_of_month) }
    let!(:in_progress_assigned_project_next_year) { create(:conversion_project, assigned_to: user, conversion_date: (Date.today + 1.year).at_beginning_of_month) }
    let!(:completed_assigned_project) { create(:conversion_project, :completed, assigned_to: user, completed_at: Date.yesterday) }

    context "when signed in as a Regional caseworker" do
      let(:user) { create(:regional_casework_services_user) }

      scenario "they can view all in progress projects" do
        view_in_progress_projects
      end

      scenario "they can view assigned completed" do
        view_completed_projects
      end
    end

    context "when signed in as a Regional caseworker team lead" do
      let(:user) { create(:regional_casework_services_team_lead_user) }

      scenario "they can view all in progress projects" do
        view_in_progress_projects
      end

      scenario "they can view assigned completed" do
        view_completed_projects
      end
    end

    context "when signed in as a Regional delivery officer" do
      let(:user) { create(:regional_delivery_officer_user) }

      scenario "they can view all in progress projects" do
        view_in_progress_projects
      end

      scenario "they can view assigned completed" do
        view_completed_projects
      end
    end

    def view_in_progress_projects
      visit in_progress_your_projects_path

      expect(page).to have_content(I18n.t("project.user.in_progress.title"))

      within(".govuk-table") do
        expect(page).to have_content(in_progress_assigned_project.urn)
        expect(page).not_to have_content(completed_assigned_project.urn)

        expect(page).not_to have_content(in_progress_other_user_project.urn)
        expect(page).not_to have_content(in_progress_unassigned_project.urn)

        expect(page).not_to have_content(completed_other_user_project.urn)
        expect(page).not_to have_content(completed_unassigned_project.urn)
      end
    end

    def view_completed_projects
      visit completed_your_projects_path

      expect(page).to have_content(I18n.t("project.user.completed.title"))

      within("tbody") do
        expect(page).to have_content(completed_assigned_project.urn)
        expect(page).not_to have_content(in_progress_assigned_project.urn)

        expect(page).not_to have_content(in_progress_other_user_project.urn)
        expect(page).not_to have_content(in_progress_unassigned_project.urn)

        expect(page).not_to have_content(completed_other_user_project.urn)
        expect(page).not_to have_content(completed_unassigned_project.urn)
      end
    end
  end
end

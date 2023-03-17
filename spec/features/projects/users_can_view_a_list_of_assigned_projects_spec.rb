require "rails_helper"

RSpec.feature "Viewing assigend projects" do
  before do
    sign_in_with_user(user)
    mock_successful_api_response_to_create_any_project
    mock_pre_fetched_api_responses_for_any_establishment_and_trust
  end

  let!(:other_user) { create(:user, :caseworker, email: "other.user@education.gov.uk") }

  let!(:completed_other_user_project) { create(:conversion_project, urn: 126041, assigned_to: other_user, completed_at: Date.yesterday) }
  let!(:in_progress_other_user_project) { create(:conversion_project, urn: 121813, assigned_to: other_user) }

  let!(:completed_unassigned_project) { create(:conversion_project, urn: 121583, assigned_to: nil, completed_at: Date.yesterday) }
  let!(:in_progress_unassigned_project) { create(:conversion_project, urn: 115652, assigned_to: nil) }

  let!(:completed_assigned_project) { create(:conversion_project, urn: 114067, assigned_to: user, completed_at: Date.yesterday) }

  context "when there are no projects" do
    let(:user) { create(:user, :caseworker) }

    scenario "they can view a helpful message" do
      visit user_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.index.empty"))
    end
  end

  context "when there are projects" do
    let!(:in_progress_assigned_project) { create(:conversion_project, urn: 103835, assigned_to: user) }

    context "when signed in as a Regional caseworker" do
      let(:user) { create(:user, :caseworker) }

      scenario "they can view all in progress projects" do
        view_in_progress_projects
      end
    end

    context "when signed in as a Regional caseworker team lead" do
      let(:user) { create(:user, :team_leader) }

      scenario "they can view all in progress projects" do
        view_in_progress_projects
      end
    end

    context "when signed in as a Regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      scenario "they can view all in progress projects" do
        view_in_progress_projects
      end
    end

    def view_in_progress_projects
      visit user_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.user.in_progress.title"))

      within(".projects-list") do
        expect(page).to have_content(in_progress_assigned_project.urn)
        expect(page).not_to have_content(completed_assigned_project.urn)

        expect(page).not_to have_content(in_progress_other_user_project.urn)
        expect(page).not_to have_content(in_progress_unassigned_project.urn)

        expect(page).not_to have_content(completed_other_user_project.urn)
        expect(page).not_to have_content(completed_unassigned_project.urn)

        expect(page).not_to have_content(completed_assigned_project.urn)
      end
    end
  end
end

require "rails_helper"

RSpec.feature "Viewing all projects" do
  context "when there are no projects" do
    before do
      user = create(:user, :caseworker)
      sign_in_with_user(user)
    end

    scenario "they can see a helpful message" do
      visit in_progress_all_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))

      visit completed_all_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))
    end
  end

  context "when there are projects in progress" do
    before do
      sign_in_with_user(user)
      mock_successful_api_response_to_create_any_project
      mock_pre_fetched_api_responses_for_any_establishment_and_trust
    end

    let!(:completed_project) { create(:conversion_project, urn: 121583, completed_at: Date.yesterday) }
    let!(:in_progress_project) { create(:conversion_project, urn: 115652) }

    context "when signed in as a Regional caseworker" do
      let(:user) { create(:user, :caseworker) }

      scenario "they can view all in progress projects" do
        view_all_in_progress_projects
      end

      scenario "they can view all completed projects" do
        view_all_completed_projects
      end
    end

    context "when signed in as a Regional caseworker team lead" do
      let(:user) { create(:user, :team_leader) }

      scenario "they can view all in progress projects" do
        view_all_in_progress_projects
      end

      scenario "they can view all completed projects" do
        view_all_completed_projects
      end
    end

    context "when signed in as a Regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      scenario "they can view all in progress projects" do
        view_all_in_progress_projects
      end

      scenario "they can view all completed projects" do
        view_all_completed_projects
      end
    end

    def view_all_in_progress_projects
      visit in_progress_all_projects_path

      expect(page).to have_content(I18n.t("project.all.in_progress.title"))

      within("tbody") do
        expect(page).to have_content(in_progress_project.urn)

        expect(page).not_to have_content(completed_project.urn)
      end
    end

    def view_all_completed_projects
      visit completed_all_projects_path

      expect(page).to have_content(I18n.t("project.index.completed.title"))

      within("tbody") do
        expect(page).to have_content(completed_project.urn)

        expect(page).not_to have_content(in_progress_project.urn)
      end
    end
  end
end

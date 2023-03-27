require "rails_helper"

RSpec.feature "Viewing all in-progress projects" do
  context "when there are no projects" do
    before do
      user = create(:user, :caseworker)
      sign_in_with_user(user)
    end

    scenario "they can see a helpful message" do
      visit all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))

      visit sponsored_all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))

      visit voluntary_all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))
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
    let!(:sponsored_in_progress_project) { create(:conversion_project, urn: 112209, sponsor_trust_required: true) }
    let!(:voluntary_in_progress_project) { create(:conversion_project, urn: 103835, sponsor_trust_required: false) }

    context "when signed in as a Regional caseworker" do
      let(:user) { create(:user, :caseworker) }

      scenario "they can view all in progress projects" do
        view_all_in_progress_projects
      end

      scenario "they can view all in progress sponsored projects" do
        view_all_sponsored_in_progress_projects
      end

      scenario "they can view all in progress voluntary projects" do
        view_all_voluntary_in_progress_projects
      end
    end

    context "when signed in as a Regional caseworker team lead" do
      let(:user) { create(:user, :team_leader) }

      scenario "they can view all in progress projects" do
        view_all_in_progress_projects
      end

      scenario "they can view all in progress sponsored projects" do
        view_all_sponsored_in_progress_projects
      end

      scenario "they can view all in progress voluntary projects" do
        view_all_voluntary_in_progress_projects
      end
    end

    context "when signed in as a Regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      scenario "they can view all in progress projects" do
        view_all_in_progress_projects
      end

      scenario "they can view all in progress sponsored projects" do
        view_all_sponsored_in_progress_projects
      end

      scenario "they can view all in progress voluntary projects" do
        view_all_voluntary_in_progress_projects
      end
    end

    def view_all_in_progress_projects
      visit all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.all.in_progress.title"))

      within("tbody") do
        expect(page).to have_content(in_progress_project.urn)

        expect(page).not_to have_content(completed_project.urn)
      end
    end

    def view_all_sponsored_in_progress_projects
      visit sponsored_all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.all.in_progress.sponsored.title"))

      within("tbody") do
        expect(page).to have_content(sponsored_in_progress_project.urn)

        expect(page).not_to have_content(completed_project.urn)
        expect(page).not_to have_content(voluntary_in_progress_project.urn)
      end
    end

    def view_all_voluntary_in_progress_projects
      visit voluntary_all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.all.in_progress.voluntary.title"))

      within("tbody") do
        expect(page).to have_content(voluntary_in_progress_project.urn)

        expect(page).not_to have_content(completed_project.urn)
        expect(page).not_to have_content(sponsored_in_progress_project.urn)
      end
    end
  end
end

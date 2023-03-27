require "rails_helper"

RSpec.feature "Viewing all completed projects" do
  context "when there are no projects" do
    before do
      user = create(:user, :caseworker)
      sign_in_with_user(user)
    end

    scenario "they can see a helpful message" do
      visit all_completed_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))

      visit sponsored_all_completed_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))

      visit voluntary_all_completed_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))
    end
  end

  context "when there are projects" do
    before do
      sign_in_with_user(user)
      mock_successful_api_response_to_create_any_project
      mock_pre_fetched_api_responses_for_any_establishment_and_trust
    end

    let!(:completed_project) { create(:conversion_project, urn: 121583, completed_at: Date.yesterday) }
    let!(:sponsored_completed_project) { create(:conversion_project, urn: 121102, completed_at: Date.yesterday, sponsor_trust_required: true) }
    let!(:voluntary_completed_project) { create(:conversion_project, urn: 114067, completed_at: Date.yesterday, sponsor_trust_required: false) }
    let!(:in_progress_project) { create(:conversion_project, urn: 115652) }

    context "when signed in as a Regional caseworker" do
      let(:user) { create(:user, :caseworker) }

      scenario "they can view all completed projects" do
        view_all_completed_projects
      end

      scenario "they can view all sponsored completed projects" do
        view_all_sponsored_completed_projects
      end

      scenario "they can view all voluntary completed projects" do
        view_all_voluntary_completed_projects
      end
    end

    context "when signed in as a Regional caseworker team lead" do
      let(:user) { create(:user, :team_leader) }

      scenario "they can view all completed projects" do
        view_all_completed_projects
      end

      scenario "they can view all sponsored completed projects" do
        view_all_sponsored_completed_projects
      end

      scenario "they can view all voluntary completed projects" do
        view_all_voluntary_completed_projects
      end
    end

    context "when signed in as a Regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      scenario "they can view all completed projects" do
        view_all_completed_projects
      end

      scenario "they can view all sponsored completed projects" do
        view_all_sponsored_completed_projects
      end

      scenario "they can view all voluntary completed projects" do
        view_all_voluntary_completed_projects
      end
    end

    def view_all_completed_projects
      visit all_completed_projects_path

      expect(page).to have_content(I18n.t("project.all.completed.title"))

      within("tbody") do
        expect(page).to have_content(completed_project.urn)

        expect(page).not_to have_content(in_progress_project.urn)
      end
    end

    def view_all_sponsored_completed_projects
      visit sponsored_all_completed_projects_path

      expect(page).to have_content(I18n.t("project.all.completed.sponsored.title"))

      within("tbody") do
        expect(page).to have_content(sponsored_completed_project.urn)

        expect(page).not_to have_content(in_progress_project.urn)
        expect(page).not_to have_content(voluntary_completed_project.urn)
      end
    end

    def view_all_voluntary_completed_projects
      visit voluntary_all_completed_projects_path

      expect(page).to have_content(I18n.t("project.all.completed.voluntary.title"))

      within("tbody") do
        expect(page).to have_content(voluntary_completed_project.urn)

        expect(page).not_to have_content(in_progress_project.urn)
        expect(page).not_to have_content(sponsored_completed_project.urn)
      end
    end
  end
end

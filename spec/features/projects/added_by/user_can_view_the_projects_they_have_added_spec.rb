require "rails_helper"

RSpec.feature "Viewing all projects a user has added" do
  context "when there are no projects" do
    before do
      user = create(:user, :regional_delivery_officer)
      sign_in_with_user(user)
    end

    scenario "they can see a helpful message" do
      visit added_by_your_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))
    end
  end

  context "when there are projects added by the user" do
    let(:user) { create(:user, :regional_delivery_officer) }

    before do
      sign_in_with_user(user)
      mock_all_academies_api_responses
    end

    let!(:completed_project) { create(:conversion_project, :completed, urn: 121583, completed_at: Date.yesterday, regional_delivery_officer: user) }
    let!(:in_progress_project) { create(:conversion_project, urn: 115652, regional_delivery_officer: user) }
    let!(:sponsored_in_progress_project) { create(:conversion_project, urn: 112209, directive_academy_order: true, regional_delivery_officer: user) }
    let!(:voluntary_in_progress_project) { create(:conversion_project, urn: 103835, directive_academy_order: false, regional_delivery_officer: user) }
    let!(:inactive_project) { create(:conversion_project, :inactive, urn: 187356, regional_delivery_officer: user) }
    let!(:other_project) { create(:conversion_project) }

    scenario "they can view all in progress projects that they added" do
      view_all_added_projects
    end

    def view_all_added_projects
      visit added_by_your_projects_path

      expect(page).to have_content(I18n.t("project.user.added_by.title"))

      within("tbody") do
        expect(page).to have_content(in_progress_project.urn)
        expect(page).to have_content(sponsored_in_progress_project.urn)
        expect(page).to have_content(voluntary_in_progress_project.urn)

        expect(page).not_to have_content(completed_project.urn)
        expect(page).not_to have_content(inactive_project.urn)
        expect(page).not_to have_content(other_project.urn)
      end
    end
  end
end

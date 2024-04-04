require "rails_helper"

RSpec.feature "Viewing all completed projects" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when there are no projects" do
    scenario "they can see a helpful message" do
      visit all_completed_projects_path

      expect(page).to have_content(I18n.t("project.table.completed.empty"))
    end
  end

  context "when there are projects" do
    let!(:completed_project) { create(:conversion_project, :completed, urn: 121583, completed_at: Date.yesterday) }
    let!(:sponsored_completed_project) { create(:conversion_project, :completed, urn: 121102, completed_at: Date.yesterday, directive_academy_order: true) }
    let!(:voluntary_completed_project) { create(:conversion_project, :completed, urn: 114067, completed_at: Date.yesterday, directive_academy_order: false) }
    let!(:in_progress_project) { create(:conversion_project, urn: 115652) }

    scenario "they can view all completed projects" do
      visit all_completed_projects_path

      expect(page).to have_content(I18n.t("project.all.completed.title"))

      within("tbody") do
        expect(page).to have_content(completed_project.urn)

        expect(page).not_to have_content(in_progress_project.urn)
      end
    end

    scenario "when there are enough projects to page they see a pager" do
      21.times do
        create(:conversion_project, :completed, completed_at: Date.today)
      end

      visit all_completed_projects_path

      expect(page).to have_css(".govuk-pagination")
    end
  end
end

require "rails_helper"

RSpec.feature "Viewing all in-progress projects" do
  before do
    user = create(:user, :caseworker)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when there are no projects" do
    scenario "they can see a helpful message" do
      visit all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.table.in_progress.empty"))
    end
  end

  context "when there are projects in progress" do
    scenario "they can view all in progress projects" do
      completed_project = create(:conversion_project, :completed, urn: 121583, completed_at: Date.yesterday)
      in_progress_project = create(:conversion_project, urn: 115652)

      visit all_in_progress_projects_path

      expect(page).to have_content(I18n.t("project.all.in_progress.title"))

      within("tbody") do
        expect(page).to have_content(in_progress_project.urn)

        expect(page).not_to have_content(completed_project.urn)
      end
    end

    scenario "they are sorted by significant date" do
      last_project = create(:conversion_project, conversion_date: Date.parse("2023-12-1"), urn: 165432)
      first_project = create(:conversion_project, conversion_date: Date.parse("2023-1-1"), urn: 123456)

      visit all_in_progress_projects_path

      within "tbody tr:first-child" do
        expect(page).to have_content(first_project.urn)
      end
      within "tbody tr:last-child" do
        expect(page).to have_content(last_project.urn)
      end
    end

    scenario "when there are enough projects to page they see a pager" do
      21.times do
        create(:conversion_project, region: :london)
      end

      visit all_in_progress_projects_path

      expect(page).to have_css(".govuk-pagination")
    end

    scenario "the projects show if they are 'Form a MAT' or not" do
      _project = create(:conversion_project, :form_a_mat, urn: 115652)

      visit all_in_progress_projects_path
      expect(page).to have_content("Form a MAT project?")
      expect(page).to have_content("Yes")
    end
  end
end

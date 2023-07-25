require "rails_helper"

RSpec.feature "Viewing all new projects" do
  context "when there are no projects" do
    before do
      user = create(:user, :caseworker)
      sign_in_with_user(user)
    end

    scenario "they can see a helpful message" do
      visit without_academy_urn_service_support_projects_path

      expect(page).to have_content(I18n.t("project.table.new.empty"))
    end
  end

  context "when there are projects in progress" do
    before do
      sign_in_with_user(user)
      mock_all_academies_api_responses
    end

    let!(:project_without_academy_urn) { create(:conversion_project, urn: 121583, academy_urn: nil) }
    let!(:project_with_academy_urn) { create(:conversion_project, urn: 115652, academy_urn: 115654) }

    context "when signed in as a Regional caseworker" do
      let(:user) { create(:user, :caseworker) }

      scenario "they can view all in progress projects" do
        view_all_new_projects
        table_has_the_correct_headers
      end
    end

    context "when signed in as a Regional caseworker team lead" do
      let(:user) { create(:user, :team_leader) }

      scenario "they can view all in progress projects" do
        view_all_new_projects
        table_has_the_correct_headers
      end
    end

    context "when signed in as a Regional delivery officer" do
      let(:user) { create(:user, :regional_delivery_officer) }

      scenario "they can view all in progress projects" do
        view_all_new_projects
        table_has_the_correct_headers
      end
    end

    def table_has_the_correct_headers
      visit without_academy_urn_service_support_projects_path

      within("thead") do
        expect(page).to have_content("School")
        expect(page).to have_content("URN")
        expect(page).to have_content("School type")
        expect(page).to have_content("School phase")
        expect(page).to have_content("Conversion date")
        expect(page).to have_content("Route")
        expect(page).to have_content("Academy name")
        expect(page).to have_content("View project")
      end
    end

    def view_all_new_projects
      visit without_academy_urn_service_support_projects_path

      expect(page).to have_content(I18n.t("service_support.section.without_urn.title"))

      within("tbody") do
        expect(page).to have_content(project_without_academy_urn.establishment.name)

        expect(page).not_to have_content(project_with_academy_urn.academy_urn)
      end
    end
  end
end

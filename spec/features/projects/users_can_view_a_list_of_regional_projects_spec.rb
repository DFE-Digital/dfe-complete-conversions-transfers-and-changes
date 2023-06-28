require "rails_helper"

RSpec.feature "Viewing regional projects" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with_user(user)
  end

  context "projects for all regions" do
    context "when there are no projects" do
      scenario "they can view a helpful message" do
        visit in_progress_regional_projects_path

        expect(page).to have_content(I18n.t("project.table.in_progress.empty"))

        visit completed_regional_projects_path

        expect(page).to have_content(I18n.t("project.table.completed.empty"))
      end
    end

    context "when there are projects" do
      before do
        mock_successful_api_response_to_create_any_project
        mock_pre_fetched_api_responses_for_any_establishment_and_trust
      end

      let!(:completed_regional_project) { create(:conversion_project, urn: 101133, team: "london", completed_at: Date.yesterday) }
      let!(:in_progress_regional_project) { create(:conversion_project, urn: 126041, team: "london", assigned_to: user) }

      let!(:completed_project) { create(:conversion_project, urn: 121583, completed_at: Date.yesterday, team: "regional_casework_services", assigned_to: user) }
      let!(:in_progress_project) { create(:conversion_project, urn: 115652, team: "regional_casework_services", assigned_to: user) }

      scenario "they can view all in progress projects" do
        visit in_progress_regional_projects_path

        expect(page).to have_content(I18n.t("project.regional.in_progress.title"))

        within("tbody") do
          expect(page).to_not have_content(in_progress_project.urn)
          expect(page).to have_content(in_progress_regional_project.urn)

          expect(page).to_not have_content(completed_project.urn)
          expect(page).to_not have_content(completed_regional_project.urn)
        end
      end

      scenario "they can view all completed projects" do
        visit completed_regional_projects_path

        expect(page).to have_content(I18n.t("project.regional.completed.title"))

        within("tbody") do
          expect(page).not_to have_content(completed_project.urn)
          expect(page).to have_content(completed_regional_project.urn)

          expect(page).to_not have_content(in_progress_project.urn)
          expect(page).to_not have_content(in_progress_regional_project.urn)
        end
      end
    end
  end

  context "projects filtered by region" do
    context "when there are no projects" do
      scenario "they can view a helpful message" do
        visit in_progress_by_region_regional_projects_path("london")

        expect(page).to have_content(I18n.t("project.table.in_progress.empty"))

        visit completed_by_region_regional_projects_path("london")

        expect(page).to have_content(I18n.t("project.table.completed.empty"))
      end
    end

    context "when the region parameter isn't a region" do
      it "renders a not_found error page" do
        visit in_progress_by_region_regional_projects_path("paris")

        expect(page).to have_content("not found")
      end
    end

    context "when there are projects" do
      before do
        mock_successful_api_response_to_create_any_project
        mock_pre_fetched_api_responses_for_any_establishment_and_trust
      end

      let!(:west_midlands_project) { create(:conversion_project, urn: 123456, region: Project.regions["west_midlands"]) }
      let!(:london_project) { create(:conversion_project, urn: 100001, region: Project.regions["london"]) }

      it "shows projects from the desired region" do
        visit in_progress_by_region_regional_projects_path("west_midlands")

        within("tbody") do
          expect(page).to have_content(west_midlands_project.urn)
          expect(page).to_not have_content(london_project.urn)
        end
      end

      context "when the region parameter has hyphens instead of underscores" do
        it "still interprets the region name correctly" do
          visit in_progress_by_region_regional_projects_path("west-midlands")

          within("tbody") do
            expect(page).to have_content(west_midlands_project.urn)
            expect(page).to_not have_content(london_project.urn)
          end
        end
      end
    end
  end
end

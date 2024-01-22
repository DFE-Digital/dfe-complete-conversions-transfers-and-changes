require "rails_helper"

RSpec.feature "Users can view academy details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  context "when the academy urn is not set" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    scenario "they see a helpful message" do
      visit project_information_path(project)

      within("#academyDetails") do
        expect(page).to have_content I18n.t("project_information.show.academy_details.empty")
      end
    end
  end

  context "when the academy urn is present" do
    let(:project) { create(:conversion_project, assigned_to: user, academy_urn: 149061) }

    context "and the details are not found" do
      scenario "they see the academy urn and a helpful message" do
        visit project_information_path(project)

        within("#academyDetails") do
          expect(page).to have_content project.academy_urn
          expect(page).to have_content I18n.t("project_information.show.academy_details.not_found")
        end
      end
    end

    context "and the details can be found" do
      let!(:establishment) { create(:gias_establishment, urn: 149061) }

      scenario "they see the academy details" do
        visit project_information_path(project)

        within("#academyDetails") do
          expect(page).to have_content project.academy_urn
          expect(page).to have_content project.academy.name
          expect(page).not_to have_content I18n.t("project_information.show.academy_details.not_found")
        end
      end
    end
  end
end

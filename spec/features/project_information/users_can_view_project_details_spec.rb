require "rails_helper"

RSpec.feature "Users can view school details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "they can view the School SharePoint link" do
    within("#projectDetails") do
      expect(page).to have_link(I18n.t("project.summary.establishment_sharepoint_link.value"), href: project.establishment_sharepoint_link)
    end
  end

  scenario "they can view the Trust SharePoint link" do
    within("#projectDetails") do
      expect(page).to have_link(I18n.t("project.summary.trust_sharepoint_link.value"), href: project.trust_sharepoint_link)
    end
  end

  context "when there are conditions from the advisory board" do
    let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

    scenario "they can view the advisory board details" do
      within("#projectDetails") do
        expect(page).to have_content(project.advisory_board_date.to_formatted_s(:govuk))
      end
    end
  end
end

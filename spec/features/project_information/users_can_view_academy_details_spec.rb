require "rails_helper"

RSpec.feature "Users can view academy details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  context "when the academy urn is not set" do
    scenario "they see a helpful message" do
      within("#academyDetails") do
        expect(page).to have_content I18n.t("project_information.show.academy_details.empty")
      end
    end
  end
end

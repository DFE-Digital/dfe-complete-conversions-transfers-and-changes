require "rails_helper"

RSpec.feature "Users can view school advisory board details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  context "when there are conditions from the advisory board" do
    let(:project) { create(:conversion_project, :with_conditions, caseworker: user) }

    scenario "they can view the advisory board details" do
      within("#advisoryBoardDetails") do
        expect(page).to have_content(project.advisory_board_date.to_formatted_s(:govuk))
      end
    end
  end
end

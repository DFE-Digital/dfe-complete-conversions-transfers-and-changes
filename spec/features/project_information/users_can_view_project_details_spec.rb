require "rails_helper"

RSpec.feature "Users can view project details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, directive_academy_order: true, sponsor_trust_required: true) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "they can see if it has had a directive academy order issued" do
    within("#projectDetails .govuk-summary-list__row:first-of-type") do
      expect(page).to have_content("Yes")
    end
  end

  scenario "they can see if it requires a sponsor trust" do
    within("#projectDetails .govuk-summary-list__row:last-of-type") do
      expect(page).to have_content("Yes")
    end
  end
end

require "rails_helper"

RSpec.feature "Users can view project details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, directive_academy_order: true, two_requires_improvement: true) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
    visit project_information_path(project)
  end

  scenario "they can see if it has had a directive academy order issued" do
    within("#reasonsFor .govuk-summary-list__row:contains('Has a directive academy order been issued?')") do
      expect(page).to have_content("Yes")
    end
  end

  scenario "they can see if it has had two 'Requires improvement' ratings" do
    within("#reasonsFor .govuk-summary-list__row:contains('Is this conversion due to intervention following 2RI?')") do
      expect(page).to have_content("Yes")
    end
  end
end

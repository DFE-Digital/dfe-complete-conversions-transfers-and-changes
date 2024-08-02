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

  context "when the project is grouped with others" do
    let(:group) { create(:project_group, group_identifier: "GRP_12345678") }
    let(:project) { create(:conversion_project, group: group) }

    scenario "they can see the group reference number" do
      within "#projectDetails" do
        expect(page).to have_content(group.group_identifier)
      end
    end
  end

  context "when the project is not grouped with others" do
    scenario "they can see an indicator" do
      within "#projectDetails" do
        expect(page).to have_content("Not grouped")
      end
    end
  end
end

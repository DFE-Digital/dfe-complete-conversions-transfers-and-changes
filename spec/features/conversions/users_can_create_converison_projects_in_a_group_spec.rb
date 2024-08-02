require "rails_helper"

RSpec.feature "Users can create new conversion projects in a group" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:urn) { 123456 }
  let(:ukprn) { 10061021 }

  before do
    sign_in_with_user(regional_delivery_officer)
  end

  scenario "by supplying the group reference number" do
    mock_successful_api_response_to_create_any_project

    visit conversions_new_path

    fill_in_new_conversion_project_form(urn, ukprn)

    fill_in "Group reference number", with: "GRP_12345678"
    click_button("Continue")

    within ".govuk-notification-banner" do
      expect(page).to have_content "Success"
    end

    expect(Project.first.group.group_identifier).to eql "GRP_12345678"
  end
end

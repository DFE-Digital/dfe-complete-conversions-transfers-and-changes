require "rails_helper"

RSpec.feature "Users can create new transfer projects in a group" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:urn) { 123456 }
  let(:incoming_ukprn) { 10061021 }
  let(:outgoing_ukprn) { 10090252 }

  before do
    Project.destroy_all
    sign_in_with_user(regional_delivery_officer)
  end

  scenario "by supplying the group reference number" do
    mock_successful_api_response_to_create_any_project

    visit transfers_new_path

    fill_in_new_transfer_project_form(urn, incoming_ukprn, outgoing_ukprn)

    fill_in "Group reference number", with: "GRP_12345678"
    click_button("Continue")

    within ".govuk-notification-banner" do
      expect(page).to have_content "Success"
    end

    expect(Project.first.group.group_identifier).to eql "GRP_12345678"
  end
end

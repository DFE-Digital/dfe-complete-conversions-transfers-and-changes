require "rails_helper"

RSpec.feature "Users can view a list of handover projects" do
  before do
    Project.destroy_all
    user = create(:regional_delivery_officer_user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "as a table" do
    conversion_project = create(:conversion_project, state: :inactive, urn: 123456, conversion_date: Date.new(2024, 2, 1))
    transfer_project = create(:transfer_project, state: :inactive, urn: 165432, transfer_date: Date.new(2024, 1, 1))

    visit root_path
    click_link "All projects"
    click_link "Handover"

    expect(page).to have_content("Projects to handover")
    expect(page).to have_content("These projects have been worked on in Prepare")

    within("tbody tr:first-of-type") do
      expect(page).to have_content(transfer_project.urn)
    end

    within("tbody tr:last-of-type") do
      expect(page).to have_content(conversion_project.urn)
    end
  end
end

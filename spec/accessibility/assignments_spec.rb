require "rails_helper"
require "axe-rspec"

RSpec.feature "Test assignment accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :team_leader) }
  let(:project) { create(:conversion_project) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "test change assigned to person for project page" do
    visit project_assign_assigned_to_path(project)

    expect(page).to have_content("Change assigned person")
    check_accessibility(page)
  end

  scenario "test change regional delivery officer for project page" do
    visit project_assign_regional_delivery_officer_path(project)

    expect(page).to have_content("Change regional delivery officer")
    check_accessibility(page)
  end
end

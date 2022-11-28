require "rails_helper"
require "axe-rspec"

RSpec.feature "Test assignment accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :team_leader) }
  let(:project) { create(:project) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "test change team lead for project page" do
    visit project_assign_team_lead_path(project)

    expect(page).to have_content("Change team lead")
    expect(page).to be_axe_clean
  end

  scenario "test change caseworker for project page" do
    visit project_assign_caseworker_path(project)

    expect(page).to have_content("Change caseworker")
    expect(page).to be_axe_clean
  end

  scenario "test change regional delivery officer for project page" do
    visit project_assign_regional_delivery_officer_path(project)

    expect(page).to have_content("Change regional delivery officer")
    expect(page).to be_axe_clean
  end
end

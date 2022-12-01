require "rails_helper"
require "axe-rspec"

RSpec.feature "Test projects accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "in progress projects page" do
    project = create(:project, regional_delivery_officer: user)
    visit projects_path

    expect(page).to have_content(project.urn)
    expect(page).to be_axe_clean
  end

  scenario "completed projects page" do
    completed_project = create(:project, regional_delivery_officer: user, completed_at: Date.today)
    visit completed_projects_path

    expect(page).to have_content(completed_project.urn)
    expect(page).to be_axe_clean
  end

  scenario "new voluntary conversion projects page" do
    visit conversion_voluntary_new_path

    expect(page).to have_content("Add a new project")
    expect(page).to be_axe_clean
  end

  scenario "new involuntary conversion projects page" do
    visit conversion_involuntary_new_path

    expect(page).to have_content("Add a new involuntary conversion project")
    expect(page).to be_axe_clean
  end

  scenario "project completed page" do
    project = create(:project, regional_delivery_officer: user)
    visit project_path(project)

    click_on I18n.t("project.complete.submit_button")

    expect(page).to have_content("Project completed")
    expect(page).to be_axe_clean
  end
end

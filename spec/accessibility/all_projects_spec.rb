require "rails_helper"
require "axe-rspec"

RSpec.feature "All projects", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "> In progress" do
    project = create(:conversion_project, assigned_to: user, urn: 123456)

    visit all_all_in_progress_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("In progress")
    check_accessibility(page)
  end

  scenario "> Completed" do
    project = create(:conversion_project, :completed, assigned_to: user, completed_at: Date.yesterday, urn: 123434)

    visit all_completed_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("Completed")
    check_accessibility(page)
  end

  scenario "> Statistics" do
    create(:conversion_project, assigned_to: user, urn: 123434)

    visit all_statistics_projects_path

    expect(page).to have_link("Statistics")
    check_accessibility(page)
  end

  scenario "> By month > Conversions" do
    project = create(:conversion_project, assigned_to: user, urn: 123434, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false)

    visit date_range_this_month_all_by_month_conversions_projects_path

    expect(page).to have_content(project.urn)
    check_accessibility(page)
  end
end

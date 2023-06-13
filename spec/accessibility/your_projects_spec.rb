require "rails_helper"
require "axe-rspec"

RSpec.feature "Your projects", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)
  end

  scenario "> in progress" do
    project = create(:conversion_project, assigned_to: user, urn: 123456)

    visit in_progress_user_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("Your projects")
    check_accessibility(page)
  end

  scenario "> Completed" do
    project = create(:conversion_project, assigned_to: user, completed_at: Date.yesterday, urn: 123434)

    visit completed_user_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("Completed")
    check_accessibility(page)
  end

  scenario "> Added by you" do
    project = create(:conversion_project, regional_delivery_officer: user, urn: 120532)

    visit added_by_user_projects_path

    expect(page).to have_content(project.urn)
    expect(page).to have_link("Added by you")
    check_accessibility(page)
  end
end

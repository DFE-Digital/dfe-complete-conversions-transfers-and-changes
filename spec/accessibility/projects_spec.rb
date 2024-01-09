require "rails_helper"
require "axe-rspec"

RSpec.feature "Test projects accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "in progress projects page" do
    project = create(:conversion_project, regional_delivery_officer: user, assigned_to: user)
    visit in_progress_your_projects_path

    expect(page).to have_content(project.urn)
    check_accessibility(page)
  end

  scenario "completed projects page" do
    completed_project = create(:conversion_project, assigned_to: user, completed_at: Date.today)
    visit completed_your_projects_path

    expect(page).to have_content(completed_project.urn)
    check_accessibility(page)
  end

  scenario "new conversion projects page" do
    visit conversions_new_path

    expect(page).to have_content(I18n.t("conversion_project.new.title"))
    check_accessibility(page)
  end

  scenario "project completed page" do
    tasks_data = create(:conversion_tasks_data, receive_grant_payment_certificate_check_certificate: true, receive_grant_payment_certificate_save_certificate: true, receive_grant_payment_certificate_date_received: Date.today)
    project = create(:conversion_project,
      regional_delivery_officer: user,
      assigned_to: user,
      tasks_data: tasks_data,
      conversion_date: 1.month.ago.at_beginning_of_month,
      conversion_date_provisional: false,
      all_conditions_met: true)
    visit project_path(project)

    click_on I18n.t("project.complete.submit_button")

    expect(page).to have_content("Project completed")
    check_accessibility(page)
  end
end

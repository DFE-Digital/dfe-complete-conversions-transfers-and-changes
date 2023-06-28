require "rails_helper"
require "axe-rspec"

RSpec.feature "Test projects accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
  let(:mock_trusts_fetcher) { double(TrustsFetcherService, call!: true) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)

    allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
    allow(TrustsFetcherService).to receive(:new).and_return(mock_trusts_fetcher)
  end

  scenario "in progress projects page" do
    project = create(:conversion_project, regional_delivery_officer: user, assigned_to: user)
    visit in_progress_user_projects_path

    expect(page).to have_content(project.urn)
    check_accessibility(page)
  end

  scenario "completed projects page" do
    completed_project = create(:conversion_project, assigned_to: user, completed_at: Date.today)
    visit completed_user_projects_path

    expect(page).to have_content(completed_project.urn)
    check_accessibility(page)
  end

  scenario "new voluntary conversion projects page" do
    visit conversions_new_path

    expect(page).to have_content(I18n.t("conversion_project.voluntary.new.title"))
    check_accessibility(page)
  end

  scenario "project completed page" do
    tasks_data = create(:conversion_tasks_data,
      receive_grant_payment_certificate_check_and_save: true,
      receive_grant_payment_certificate_update_kim: true,
      receive_grant_payment_certificate_update_sheet: true,
      conditions_met_confirm_all_conditions_met: true)
    project = create(:conversion_project,
      regional_delivery_officer: user,
      assigned_to: user,
      tasks_data: tasks_data,
      conversion_date: 1.month.ago.at_beginning_of_month,
      conversion_date_provisional: false)
    visit project_path(project)

    click_on I18n.t("project.complete.submit_button")

    expect(page).to have_content("Project completed")
    check_accessibility(page)
  end
end

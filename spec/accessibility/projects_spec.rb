require "rails_helper"
require "axe-rspec"

RSpec.feature "Test projects accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
  let(:mock_trusts_fetcher) { double(IncomingTrustsFetcher, call: true) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)

    allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
    allow(IncomingTrustsFetcher).to receive(:new).and_return(mock_trusts_fetcher)
  end

  scenario "in progress projects page" do
    project = create(:conversion_project, regional_delivery_officer: user)
    visit projects_path

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
    visit new_conversions_voluntary_project_path

    expect(page).to have_content(I18n.t("conversion_project.voluntary.new.title"))
    check_accessibility(page)
  end

  scenario "new involuntary conversion projects page" do
    visit new_conversions_involuntary_project_path

    expect(page).to have_content(I18n.t("conversion_project.involuntary.new.title"))
    check_accessibility(page)
  end

  scenario "project completed page" do
    project = create(:conversion_project, regional_delivery_officer: user, assigned_to: user)
    visit project_path(project)

    click_on I18n.t("project.complete.submit_button")

    expect(page).to have_content("Project completed")
    check_accessibility(page)
  end
end

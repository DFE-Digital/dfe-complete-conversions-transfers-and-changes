require "rails_helper"

RSpec.feature "Users can edit project details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, incoming_trust_ukprn: 10059151, assigned_to: user) }

  before do
    sign_in_with_user(user)
    mock_api_for_editing
  end

  scenario "they can change the incoming trust UKPRN" do
    visit project_information_path(project)

    ukprn_row = find("#incomingTrustDetails .govuk-summary-list__row:nth-child(2)")

    within(ukprn_row) do
      click_link "Change"
    end

    fill_in "Incoming trust UKPRN (UK Provider Reference Number)", with: "10058882"
    click_button "Continue"

    within(ukprn_row) do
      expect(page).to have_content "10058882"
    end
  end

  scenario "they can change the advisory board date" do
    visit project_information_path(project)

    row = find("#advisoryBoardDetails .govuk-summary-list__row:nth-child(1)")

    within(row) do
      click_link "Change"
    end

    date_value = Date.yesterday

    fill_in "Day", with: date_value.day
    fill_in "Month", with: date_value.month
    fill_in "Year", with: date_value.year

    click_button "Continue"

    within(row) do
      expect(page).to have_content date_value.to_fs(:govuk)
    end
  end

  scenario "they can change the advisory board conditions" do
    visit project_information_path(project)

    row = find("#advisoryBoardDetails .govuk-summary-list__row:nth-child(2)")

    within(row) do
      click_link "Change"
    end

    text_value = "These are the conditions for the conversion."

    fill_in "Advisory board conditions", with: text_value

    click_button "Continue"

    within(row) do
      expect(page).to have_content text_value
    end
  end

  scenario "they can change the sharepoint link for an establishment" do
    visit project_information_path(project)

    row = find("#schoolDetails .govuk-summary-list__row:nth-child(7)")

    within(row) do
      click_link "Change"
    end

    fill_in "School SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"
    click_on "Continue"

    expect(page).to have_content "Project has been updated successfully"

    expect(page).to have_link "View the school SharePoint folder (opens in a new tab)",
      href: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"
  end

  scenario "they can change the sharepoint link for an incoming trust" do
    visit project_information_path(project)

    row = find("#incomingTrustDetails .govuk-summary-list__row:nth-child(6)")

    within(row) do
      click_link "Change"
    end

    fill_in "Incoming trust SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"
    click_on "Continue"

    expect(page).to have_content "Project has been updated successfully"

    expect(page).to have_link "View the trust SharePoint folder (opens in a new tab)",
      href: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"
  end
end

def mock_api_for_editing
  establishment = build(:academies_api_establishment)
  local_authority = build(:local_authority)
  allow(establishment).to receive(:local_authority).and_return(local_authority)

  mock_establishment = Api::AcademiesApi::Client::Result.new(establishment, nil)

  trust = build(:academies_api_trust, ukprn: 10059151)
  mock_before_trust = Api::AcademiesApi::Client::Result.new(trust, nil)

  trust = build(:academies_api_trust, ukprn: 10058882)
  mock_after_trust = Api::AcademiesApi::Client::Result.new(trust, nil)

  test_client = Api::AcademiesApi::Client.new
  allow(test_client).to receive(:get_establishment).with(123456).and_return(mock_establishment)
  allow(test_client).to receive(:get_trust).with(10059151).and_return(mock_before_trust)
  allow(test_client).to receive(:get_trust).with(10058882).and_return(mock_after_trust)
  allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
end

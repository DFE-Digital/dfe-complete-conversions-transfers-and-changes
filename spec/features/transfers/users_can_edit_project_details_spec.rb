require "rails_helper"

RSpec.feature "Users can edit transfer project details" do
  let(:user) { create(:user, :caseworker) }
  let(:project) do
    create(
      :transfer_project,
      incoming_trust_ukprn: 10059151,
      outgoing_trust_ukprn: 10059797,
      assigned_to: user
    )
  end

  before do
    sign_in_with_user(user)
    mock_api_for_editing
  end

  scenario "they can change the outgoing trust UKPRN" do
    visit project_information_path(project)

    row = find("#outgoingTrustDetails .govuk-summary-list__row:nth-child(2)")

    within(row) do
      click_link "Change"
    end

    fill_in "Outgoing trust UKPRN (UK Provider Reference Number)", with: "10058882"
    click_button "Continue"

    within(row) do
      expect(page).to have_content "10058882"
    end
  end

  scenario "they can change the sharepoint link for an establishment" do
    visit project_information_path(project)

    row = find("#academyDetails .govuk-summary-list__row:nth-child(6)")

    within(row) do
      click_link "Change"
    end

    fill_in "School SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"
    click_on "Continue"

    expect(page).to have_content "Project has been updated successfully"

    within(row) do
      expect(page).to have_link "View the academy SharePoint folder (opens in a new tab)",
        href: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"
    end
  end

  scenario "they can change the sharepoint link for an outgoing trust" do
    visit project_information_path(project)

    row = find("#outgoingTrustDetails .govuk-summary-list__row:nth-child(6)")

    within(row) do
      click_link "Change"
    end

    fill_in "Outgoing trust SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"
    click_on "Continue"

    expect(page).to have_content "Project has been updated successfully"

    within(row) do
      expect(page).to have_link "View the trust SharePoint folder (opens in a new tab)",
        href: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"
    end
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

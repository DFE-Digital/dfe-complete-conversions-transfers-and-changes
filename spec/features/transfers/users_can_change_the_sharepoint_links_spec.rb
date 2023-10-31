require "rails_helper"

RSpec.feature "Users can change a transfer projects sharepoint links" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:transfer_project, establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment-folder", incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder", assigned_to: user) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  scenario "they can navigate to the edit page" do
    visit project_information_path(project)

    within "#academyDetails" do
      expect(page).to have_link("Change")
    end

    within "#incomingTrustDetails" do
      expect(page).to have_link("Change")
    end

    within "#outgoingTrustDetails" do
      expect(page).to have_link("Change")
    end
  end

  context "when a project update successfully saves" do
    scenario "they can change the sharepoint link for an establishment and see a confirmation message" do
      visit transfers_update_path(project.id)

      fill_in "School SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/establishment-folder-updated-link"
      click_on "Continue"

      expect(page).to have_content(I18n.t("project.update.success"))
    end

    scenario "they can change the sharepoint link for an incoming trust and see a confirmation message" do
      visit transfers_update_path(project.id)

      fill_in "Incoming trust SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder-updated-link"
      click_on "Continue"

      expect(page).to have_content(I18n.t("project.update.success"))
    end

    scenario "they can change the sharepoint link for an outgoing trust and see a confirmation message" do
      visit transfers_update_path(project.id)

      fill_in "Outgoing trust SharePoint folder link", with: "https://educationgovuk-my.sharepoint.com/outgoing-trust-folder-updated-link"
      click_on "Continue"

      expect(page).to have_content(I18n.t("project.update.success"))
    end
  end

  scenario "they can cancel the change if needed" do
    visit transfers_update_path(project.id)

    click_on "Cancel"

    expect(page).to have_content(project.establishment.name)
  end

  context "when the form is invalid" do
    scenario "redirected to the edit page with a validation error" do
      visit transfers_update_path(project.id)

      fill_in "School SharePoint folder link", with: "this is not a link"
      fill_in "Incoming trust SharePoint folder link", with: "sdkjsdfkjhdsf"
      fill_in "Outgoing trust SharePoint folder link", with: "this is also not a link"
      click_on "Continue"

      expect(page).to have_content("Enter a school SharePoint link in the correct format")
      expect(page).to have_content("The incoming trust SharePoint link must have the https scheme")
      expect(page).to have_content("Enter a outgoing trust SharePoint link in the correct format")
    end
  end
end

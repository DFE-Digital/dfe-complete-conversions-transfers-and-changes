require "rails_helper"

RSpec.feature "Users can create new conversion projects" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(regional_delivery_officer)
    visit transfers_new_path
  end

  context "when the URN and UKPRN are valid" do
    let(:urn) { 123456 }
    let(:incoming_ukprn) { 10061021 }
    let(:outgoing_ukprn) { 10090252 }
    let(:two_weeks_ago) { Date.today - 2.weeks }
    let(:two_months_time) { Date.today + 2.months }

    before { mock_all_academies_api_responses }

    scenario "a new project is created" do
      fill_in_form

      click_button("Continue")

      expect(page).to have_content(I18n.t("transfer_project.created.success"))
      expect(Transfer::Project.count).to eq(1)
    end
  end

  context "when required values are not supplied" do
    scenario "error messages are shown to the user" do
      click_button("Continue")

      expect(page).to have_content("There is a problem")
    end
  end

  def fill_in_form
    fill_in "School URN", with: urn
    fill_in "Incoming trust UKPRN (UK Provider Reference Number)", with: incoming_ukprn
    fill_in "Outgoing trust UKPRN (UK Provider Reference Number)", with: outgoing_ukprn

    fill_in "School SharePoint link", with: "https://educationgovuk-my.sharepoint.com/school-folder"
    fill_in "Incoming trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder"
    fill_in "Outgoing trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/outgoing-trust-folder"

    within("#advisory-board-date") do
      fill_in "Day", with: two_weeks_ago.day
      fill_in "Month", with: two_weeks_ago.month
      fill_in "Year", with: two_weeks_ago.year
    end

    within("#provisional-transfer-date") do
      fill_in "Month", with: two_months_time.month
      fill_in "Year", with: two_months_time.year
    end
  end
end

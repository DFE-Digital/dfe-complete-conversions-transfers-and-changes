require "rails_helper"

RSpec.feature "Users can create new transfer projects" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  context "single transferer projects" do
    before do
      sign_in_with_user(regional_delivery_officer)
      visit transfers_new_path
    end

    context "when the URN and UKPRN are valid" do
      let(:urn) { 123456 }
      let(:incoming_ukprn) { 10061021 }
      let(:outgoing_ukprn) { 10090252 }
      let(:new_trust_reference_number) { nil }
      let(:two_weeks_ago) { Date.today - 2.weeks }
      let(:two_months_time) { Date.today + 2.months }

      before { mock_all_academies_api_responses }

      scenario "a new project is created" do
        visit new_project_path
        choose "Transfer"
        click_button "Continue"

        fill_in_form

        click_button("Continue")

        expect(page).to have_content(I18n.t("transfer_project.created.success"))
        expect(Transfer::Project.count).to eq(1)
      end
    end

    context "when required values are not supplied" do
      scenario "error messages are shown to the user" do
        visit new_project_path
        choose "Transfer"

        click_button "Continue"

        click_button("Continue")

        expect(page).to have_content("There is a problem")
      end
    end
  end

  context "form a MAT transfer projects" do
    before do
      sign_in_with_user(regional_delivery_officer)
      visit transfers_new_mat_path
    end

    context "when the URN, UKPRN and new Trust reference number are valid" do
      let(:urn) { 123456 }
      let(:outgoing_ukprn) { 10090252 }
      let(:incoming_ukprn) { nil }
      let(:new_trust_reference_number) { "TR12345" }
      let(:two_weeks_ago) { Date.today - 2.weeks }
      let(:two_months_time) { Date.today + 2.months }

      before { mock_all_academies_api_responses }

      scenario "a new project is created" do
        visit new_project_path
        choose "Form a MAT transfer"
        click_button "Continue"

        fill_in_form

        click_button("Continue")

        expect(page).to have_content(I18n.t("transfer_project.form_a_mat.created.success"))
        expect(Transfer::Project.count).to eq(1)
      end
    end

    context "when required values are not supplied" do
      scenario "error messages are shown to the user" do
        visit new_project_path
        choose "Form a MAT transfer"
        click_button "Continue"

        click_button("Continue")

        expect(page).to have_content("There is a problem")
      end
    end
  end

  def fill_in_form
    fill_in "Academy URN", with: urn
    fill_in "Incoming trust UKPRN", with: incoming_ukprn if incoming_ukprn
    fill_in "Trust reference number (TRN)", with: new_trust_reference_number if new_trust_reference_number
    fill_in "Trust name", with: "New Trust" if new_trust_reference_number
    fill_in "Outgoing trust UKPRN (UK Provider Reference Number)", with: outgoing_ukprn

    fill_in "Academy SharePoint link", with: "https://educationgovuk-my.sharepoint.com/school-folder"
    fill_in "Incoming trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/incoming-trust-folder"
    fill_in "Outgoing trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/outgoing-trust-folder"

    within("#advisory-board-date") do
      fill_in "Day", with: two_weeks_ago.day
      fill_in "Month", with: two_weeks_ago.month
      fill_in "Year", with: two_weeks_ago.year
    end

    within("#two-requires-improvement") do
      choose "No"
    end

    within("#inadequate-ofsted") do
      choose "No"
    end

    within("#financial-safeguarding-governance-issues") do
      choose "No"
    end

    within("#outgoing-trust-to-close") do
      choose "No"
    end

    fill_in "Handover comments", with: "This is a handover note."

    within("#provisional-transfer-date") do
      fill_in "Month", with: two_months_time.month
      fill_in "Year", with: two_months_time.year
    end

    within "#assigned-to-regional-caseworker-team" do
      choose "No"
    end
  end
end

require "rails_helper"

RSpec.feature "Users can create new involuntary conversion projects" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(regional_delivery_officer)
    visit new_conversions_involuntary_project_path
  end

  context "when the URN and UKPRN are valid" do
    let(:urn) { 123456 }
    let(:ukprn) { 10061021 }
    let(:two_weeks_ago) { Date.today - 2.weeks }

    before { mock_successful_api_responses(urn: urn, ukprn: ukprn) }

    scenario "a new project is created" do
      expect(page).to have_content(I18n.t("conversion_project.involuntary.new.title"))
      fill_in "School URN", with: urn
      fill_in "Incoming trust UK Provider Reference Number (UKPRN)", with: ukprn

      within("#provisional-conversion-date") do
        completion_date = Date.today.at_beginning_of_month + 1.year
        fill_in "Month", with: completion_date.month
        fill_in "Year", with: completion_date.year
      end

      fill_in "School SharePoint link", with: "https://educationgovuk-my.sharepoint.com/school-folder"
      fill_in "Trust SharePoint link", with: "https://educationgovuk-my.sharepoint.com/trust-folder"

      within("#advisory-board-date") do
        fill_in "Day", with: two_weeks_ago.day
        fill_in "Month", with: two_weeks_ago.month
        fill_in "Year", with: two_weeks_ago.year
      end

      fill_in "Advisory board conditions", with: "This school must:\n1. Do this\n2. And that"

      fill_in "Handover comments", with: "A new handover comment"

      within("#directive-academy-order") do
        choose "Yes"
      end

      within("#sponsor-trust-required") do
        choose "Yes"
      end

      click_button("Continue")

      expect(page).to have_content(I18n.t("project.show.title"))
      expect(page).to have_content("Project kick-off")

      click_on("Project information")

      expect(page).to have_content(two_weeks_ago.to_formatted_s(:govuk))
    end

    scenario "there is no option to assign the project to the Regional Caseworker Team" do
      expect(page).to_not have_content(I18n.t("helpers.hint.conversion_project.assigned_to_regional_caseworker_team"))
    end
  end
end

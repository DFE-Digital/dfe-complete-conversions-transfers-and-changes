require "rails_helper"

RSpec.feature "Users can create new conversion projects" do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(regional_delivery_officer)
  end

  context "when the URN and UKPRN are valid" do
    let(:urn) { 123456 }
    let(:ukprn) { 10061021 }
    let(:two_weeks_ago) { Date.today - 2.weeks }

    before { mock_successful_api_responses(urn: urn, ukprn: ukprn) }

    scenario "a new project is created" do
      visit new_project_path
      choose "Conversion"
      click_button "Continue"

      fill_in_new_conversion_project_form(urn, ukprn)

      click_button("Continue")

      expect(page).to have_content(I18n.t("project.show.title"))
      expect(page).to have_content("Project kick-off")
      expect(page).to have_content("Handover with regional delivery officer")

      click_on("About the project")

      expect(page).to have_content(two_weeks_ago.to_formatted_s(:govuk))
    end

    scenario "there is an option to assign the project to the Regional Caseworker Team" do
      visit new_project_path
      choose "Conversion"
      click_button "Continue"

      expect(page).to have_content(I18n.t("helpers.hint.conversion_project.assigned_to_regional_caseworker_team"))
    end
  end
end

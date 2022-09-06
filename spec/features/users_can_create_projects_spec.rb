require "rails_helper"

RSpec.feature "Users can create new projects" do
  let(:mock_workflow) { file_fixture("workflows/conversion.yml") }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    sign_in_with_user(regional_delivery_officer)
    visit new_project_path

    allow(YAML).to receive(:load_file).with(Rails.root.join("app", "workflows", "conversion.yml")).and_return(
      YAML.load_file(mock_workflow)
    )
  end

  context "when the URN and UKPRN are valid" do
    let(:urn) { 123456 }
    let(:ukprn) { 10061021 }

    before { mock_successful_api_responses(urn: urn, ukprn: ukprn) }

    scenario "a new project is created" do
      fill_in "School URN", with: urn
      fill_in "Incoming trust UK Provider Reference Number (UKPRN)", with: ukprn
      fill_in "Month", with: 12
      fill_in "Year", with: 2025
      fill_in "Handover comments", with: "A new handover comment"

      click_button("Continue")

      expect(page).to have_content(I18n.t("project.show.title"))
      expect(page).to have_content("Starting the project")
      expect(page).to have_content("Understand history and complete handover from Pre-AB")
    end
  end
end

require "rails_helper"

RSpec.feature "Users can view the new project form" do
  context "the user is a team leader" do
    before(:each) do
      sign_in_with_user(create(:user, :team_leader))
    end

    scenario "can see the new project button" do
      visit projects_path
      expect(page).to have_content(I18n.t("project.index.new_button.text"))
    end

    scenario "can see the new project form" do
      visit new_project_path
      expect(page).to have_content(I18n.t("project.new.title"))
    end
  end

  context "the user is not a team leader" do
    before(:each) do
      sign_in_with_user(create(:user))
    end

    scenario "cannot see the new project button" do
      visit projects_path
      expect(page).to_not have_content(I18n.t("project.index.new_button.text"))
    end

    scenario "cannot see the new project form" do
      visit new_project_path
      expect(page).to have_content(I18n.t("unauthorised_action.message"))
    end
  end
end

RSpec.feature "Team leaders can create a new project" do
  let(:mock_workflow) { file_fixture("workflows/conversion.yml") }
  let(:team_leader) { create(:user, :team_leader) }
  let(:regional_delivery_officer_email) { "regional-deliver-officer@education.gov.uk" }
  let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer, email: regional_delivery_officer_email) }

  before do
    sign_in_with_user(team_leader)
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
      select regional_delivery_officer_email, from: "Regional delivery officer"

      click_button("Continue")

      expect(page).to have_content(I18n.t("project.show.title"))
      expect(page).to have_content("Starting the project")
      expect(page).to have_content("Understand history and complete handover from Pre-AB")
    end
  end
end

require "rails_helper"

RSpec.feature "Users can edit the Academy URN" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  context "when the user does not enter a URN in the Academy URN field" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    scenario "the user sees an error message" do
      _project = create(:conversion_project, assigned_to: user, academy_urn: nil)
      visit without_academy_urn_service_support_projects_path

      click_on "Create academy URN"
      click_on "Save and return"

      expect(page).to have_content("Please enter an Academy URN")
    end
  end

  context "when the Academy URN is invalid" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    scenario "the user sees an error message" do
      _project = create(:conversion_project, assigned_to: user, academy_urn: nil)
      visit without_academy_urn_service_support_projects_path

      click_on "Create academy URN"
      fill_in "conversion_project[academy_urn]", with: "FFFFFF"
      click_on "Save and return"

      expect(page).to have_content("Please enter a valid URN. The URN must be 6 digits long. For example, 123456.")
    end
  end

  context "when the Academy URN is found" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    context "when the Academy URN is correct" do
      scenario "the user can save the Academy URN on the project" do
        project = create(:conversion_project, assigned_to: user, academy_urn: nil, urn: 111111)
        _academy = create(:gias_establishment, urn: 123456)
        visit without_academy_urn_service_support_projects_path

        click_on "Create academy URN"
        fill_in "conversion_project[academy_urn]", with: 123456

        click_on "Save and return"
        expect(page).to have_content("Are these details correct?")
        click_on "Yes, save and return"
        expect(page).to have_content("Academy URN 123456 added to #{project.establishment.name}, 111111")
      end
    end

    context "when the Academy URN is incorrect" do
      scenario "the user can go back to the list by clicking Cancel" do
        project = create(:conversion_project, assigned_to: user, academy_urn: nil)
        _academy = create(:gias_establishment, urn: 165432)
        visit without_academy_urn_service_support_projects_path

        click_on "Create academy URN"
        fill_in "conversion_project[academy_urn]", with: 165432

        click_on "Save and return"
        expect(page).to have_content("Are these details correct?")
        click_on "Cancel"
        expect(page).to have_content("URNs to create")
        expect(page).to have_content(project.establishment.name)
      end
    end
  end

  context "when the Academy URN is not found" do
    before do
      mock_successful_api_trust_response(ukprn: any_args)
      mock_academies_api_establishment_success(urn: 111111)
    end

    scenario "the user sees a helpful message and can go back and search again" do
      project = create(:conversion_project, assigned_to: user, academy_urn: nil, urn: 111111)
      visit without_academy_urn_service_support_projects_path

      click_on "Create academy URN"
      fill_in "conversion_project[academy_urn]", with: 123456

      click_on "Save and return"
      expect(page).to have_content("No information found for URN 123456")

      click_on "Enter URN again"
      expect(page).to have_content("Create academy URN for #{project.establishment.name} conversion")
    end
  end
end

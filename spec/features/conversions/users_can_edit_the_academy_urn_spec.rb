require "rails_helper"

RSpec.feature "Users can edit the Academy URN" do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_pre_fetched_api_responses_for_any_establishment_and_trust
    sign_in_with_user(user)
  end

  context "when the user does not enter a URN in the Academy URN field" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    scenario "the user sees an error message" do
      _project = create(:conversion_project, assigned_to: user, academy_urn: nil)
      visit new_all_projects_path

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
      visit new_all_projects_path

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
        visit new_all_projects_path

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
        visit new_all_projects_path

        click_on "Create academy URN"
        fill_in "conversion_project[academy_urn]", with: 123456

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
      mock_successful_api_establishment_response(urn: 111111)
      mock_establishment_not_found(urn: 123456)
    end

    scenario "the user sees a helpful message and can go back and search again" do
      project = create(:conversion_project, assigned_to: user, academy_urn: nil, urn: 111111)
      visit new_all_projects_path

      click_on "Create academy URN"
      fill_in "conversion_project[academy_urn]", with: 123456

      click_on "Save and return"
      expect(page).to have_content("No information found for URN 123456")

      click_on "Enter URN again"
      expect(page).to have_content("Create academy URN for #{project.establishment.name} conversion")
    end
  end

  context "when the Academies API returns an error" do
    before do
      mock_successful_api_trust_response(ukprn: any_args)
      mock_successful_api_establishment_response(urn: 111111)
      mock_timeout_api_establishment_response(urn: 123456)
    end

    scenario "the user sees a helpful message" do
      _project = create(:conversion_project, assigned_to: user, academy_urn: nil, urn: 111111)
      visit new_all_projects_path

      click_on "Create academy URN"
      fill_in "conversion_project[academy_urn]", with: 123456

      click_on "Save and return"
      expect(page).to have_content("The service timed out when getting the details of the school or trust.")
    end
  end
end

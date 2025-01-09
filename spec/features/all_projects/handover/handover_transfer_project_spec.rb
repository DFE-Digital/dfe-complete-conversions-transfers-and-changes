require "rails_helper"

RSpec.feature "Handover a transfer project" do
  before do
    Project.destroy_all
    application_user = create(:regional_delivery_officer_user)
    sign_in_with_user(application_user)
    mock_all_academies_api_responses
  end

  scenario "to the Regional team" do
    prepare_user = create(:user, email: "prepare.user@education.gov.uk", first_name: "Prepare", last_name: "User", team: "east_midlands")
    project = create(:transfer_project, :inactive, regional_delivery_officer: prepare_user)

    visit all_handover_projects_path

    expect(page).to have_content(project.urn)

    click_link "Add handover details"

    expect(page).to have_content("Check you have the right project")
    expect(page).to have_content(project.urn)

    click_link "Confirm"

    expect(page).to have_content("Will RCS (Regional Casework Services) manage this project next?")

    within "#assigned-to-regional-caseworker-team" do
      choose "No"
    end
    fill_in "School SharePoint link", with: "https://educationgovuk.sharepoint.com/establishment"
    fill_in "Incoming trust SharePoint link", with: "https://educationgovuk.sharepoint.com/incoming-trust"
    fill_in "Outgoing trust SharePoint link", with: "https://educationgovuk.sharepoint.com/outgoing-trust"
    click_button "Confirm"

    expect(page).to have_content("Project assigned")
    expect(page).to have_link("add contact details")
    expect(page).to have_link("return to the list of projects to handover")
  end

  scenario "to the Regional Casework Services team" do
    prepare_user = create(:user, email: "prepare.user@education.gov.uk", first_name: "Prepare", last_name: "User", team: "east_midlands")
    project = create(:transfer_project, :inactive, regional_delivery_officer: prepare_user)

    visit all_handover_projects_path

    expect(page).to have_content(project.urn)

    click_link "Add handover details"

    expect(page).to have_content("Check you have the right project")
    expect(page).to have_content(project.urn)

    click_link "Confirm"

    expect(page).to have_content("Will RCS (Regional Casework Services) manage this project next?")

    within "#assigned-to-regional-caseworker-team" do
      choose "Yes"
    end
    fill_in "Handover comments", with: "Test handover comments.\n\nThese are the handover comments for tests."
    fill_in "School SharePoint link", with: "https://educationgovuk.sharepoint.com/establishment"
    fill_in "Incoming trust SharePoint link", with: "https://educationgovuk.sharepoint.com/incoming-trust"
    fill_in "Outgoing trust SharePoint link", with: "https://educationgovuk.sharepoint.com/outgoing-trust"
    click_button "Confirm"

    expect(page).to have_content("Project handed over to Regional Casework Services")
    expect(page).to have_link("add contact details")
    expect(page).to have_link("return to the list of projects to handover")
  end
end

require "rails_helper"

RSpec.feature "Users can view a transfer" do
  before do
    user = create(:user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:transfer_project) { create(:transfer_project) }

  scenario "they can view the summary" do
    visit project_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("transfer")
    expect(page).to have_content("West Midlands")
    expect(page).to have_link("Academy folder (opens in new tab)", href: "https://educationgovuk-my.sharepoint.com/establishment-folder")
  end

  scenario "they can navigate the sub sections" do
    visit project_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_link("Task list")
    expect(page).to have_link("About the project")
    expect(page).to have_link("Notes")
    expect(page).to have_link("External contacts")
    expect(page).to have_link("Internal contacts")
  end

  scenario "they can view the task list" do
    visit project_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("Task list")
  end

  scenario "they can view the project information" do
    visit project_information_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("Project details")
    expect(page).to have_content("Reasons for the transfer")
    expect(page).to have_content("Advisory board details")
    expect(page).to have_content("Academy details")
    expect(page).to have_content("Incoming trust details")
    expect(page).to have_content("Outgoing trust details")
  end

  scenario "they can view the notes" do
    visit project_notes_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("Notes")
  end

  scenario "they can view the external contacts" do
    mock_successful_persons_api_client

    visit project_contacts_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("External contacts")
  end

  scenario "they can view the internal contacts" do
    visit project_internal_contacts_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("Internal contacts")
  end

  context "when the project is a Form a MAT conversion" do
    let(:project) { create(:transfer_project, :form_a_mat) }

    scenario "they can see a Form a MAT label" do
      visit project_path(project)

      within(".govuk-caption-l .govuk-tag--pink") do
        expect(page).to have_content("Form a MAT")
      end
    end
  end
end

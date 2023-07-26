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
    expect(page).to have_content("Advisory board details")
    expect(page).to have_content("Academy details")
    expect(page).to have_content("Incoming trust details")
    expect(page).to have_content("Outgoing trust details")
    expect(page).to have_content("Diocese details")
  end

  scenario "they can view the notes" do
    visit project_notes_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("Notes")
  end

  scenario "they can view the external contacts" do
    visit project_contacts_path(transfer_project)

    expect(page).to have_content(transfer_project.urn)
    expect(page).to have_content("External contacts")
  end
end

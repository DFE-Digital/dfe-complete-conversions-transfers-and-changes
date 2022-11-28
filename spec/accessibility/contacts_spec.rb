require "rails_helper"
require "axe-rspec"

RSpec.feature "Test contacts accessibility", driver: :headless_firefox, accessibility: true do
  let(:user) { create(:user, email: "user1@education.gov.uk") }
  let(:project) { create(:project, caseworker: user) }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  scenario "show contacts page" do
    contact = create(:contact, project: project)
    visit project_contacts_path(project)

    expect(page).to have_content(contact.name)
    expect(page).to be_axe_clean
  end

  scenario "new page" do
    visit new_project_contact_path(project)

    expect(page).to have_content("Add contact")
    expect(page).to be_axe_clean
  end

  scenario "edit page" do
    contact = create(:contact, project: project)
    visit edit_project_contact_path(project, contact)

    expect(page).to have_content("Edit contact")
    expect(page).to be_axe_clean
  end

  scenario "deleted page" do
    contact = create(:contact, project: project)
    visit project_contact_delete_path(project, contact)

    expect(page).to have_content(contact.name)
    expect(page).to be_axe_clean
  end
end
require "rails_helper"

RSpec.feature "Users can edit external contacts" do
  before do
    mock_successful_api_response_to_create_any_project
    mock_successful_persons_api_client
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }
  let!(:project) { create(:conversion_project) }
  let!(:contact) { create(:project_contact, project: project) }

  scenario "they can delete a contact" do
    visit project_contacts_path(project)
    expect(page).to have_content("Other contacts")

    expect(page).to have_content("Jo Example")
    expect(page).to have_content("Some Organisation")
    expect(page).to have_content("CEO of Learning")
    expect(page).to have_content("jo@example.com")
    expect(page).to have_content("01632 960123")

    click_link "Edit"

    click_link("Delete")

    expect(page).to have_content("Are you sure you want to delete Jo Example?")
    expect(page).to have_content("This will remove the contact for CEO of Learning called Jo Example from the contacts list.")

    click_button("Delete")

    expect(page).to have_content("There are not any contacts for this project yet.")
  end

  scenario "they can edit a contact" do
    visit project_contacts_path(project)
    expect(page).to have_content("Other contacts")

    expect(page).to have_content("Jo Example")

    click_link "Edit"

    fill_in "Full name", with: "Josephine Example"
    click_on "Save contact"
    expect(page).to have_content("Josephine Example")
  end

  context "when the contact can be set as a primary contact" do
    let!(:contact) { create(:project_contact, project: project, category: "school_or_academy") }

    scenario "they can set an existing contact as a primary contact for the organisation" do
      visit project_contacts_path(project)
      expect(page).to have_content("#{project.establishment.name} contacts")

      click_link "Edit"

      within "#primary-contact-for-category" do
        choose "Yes"
      end

      click_on "Save contact"
      expect(page).to have_content("Primary contact at organisation?")
      expect(page).to have_content("Yes")
    end
  end
end

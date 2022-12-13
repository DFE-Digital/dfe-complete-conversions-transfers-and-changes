require "rails_helper"

RSpec.feature "Users can create and view and delete contacts" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let!(:contact) { create(:contact, project: project) }
  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }

  scenario "User views contacts" do
    visit project_contacts_path(project_id)

    expect(page).to have_content("Other contacts")

    expect_page_to_have_contact(
      name: "Jo Example",
      title: "CEO of Learning",
      email: "jo@example.com",
      phone: "01632 960123"
    )

    click_link "Add contact"

    expect(page).to have_current_path(new_project_contact_path(project))

    select "Trust", from: "Contact for"
    fill_in "Name", with: "Some One"
    fill_in "Role", with: "Chief of Knowledge"
    fill_in "Email", with: "some@example.com"
    fill_in "Phone", with: "01632 960456"

    click_button("Add contact")

    expect(page).to have_current_path(project_contacts_path(project_id))

    expect(page).to have_content("Trust contacts")

    expect_page_to_have_contact(
      name: "Some One",
      title: "Chief of Knowledge",
      email: "some@example.com",
      phone: "01632 960456"
    )
  end

  scenario "User deletes a contact" do
    visit project_contacts_path(project_id)
    expect(page).to have_content("Other contacts")

    expect_page_to_have_contact(
      name: "Jo Example",
      title: "CEO of Learning",
      email: "jo@example.com",
      phone: "01632 960123"
    )

    click_link "Change"

    expect(page).to have_current_path(edit_project_contact_path(project, contact))

    click_link("Delete") # Link styled as button

    expect(page).to have_current_path(project_contact_delete_path(project, contact))
    expect(page).to have_content("Are you sure you want to delete Jo Example?")
    expect(page).to have_content("This will remove the contact for CEO of Learning called Jo Example from the contacts list.")

    click_button("Delete")

    expect(page).to have_current_path(project_contacts_path(project_id))
    expect(page).to have_content("There are not any contacts for this project yet.")
  end

  private def expect_page_to_have_contact(name:, title:, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email
    expect(page).to have_content(phone) if phone
  end
end

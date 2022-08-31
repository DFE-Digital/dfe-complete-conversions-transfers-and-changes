require "rails_helper"

RSpec.feature "Users can view contacts" do
  let(:user) { User.create!(email: "user@education.gov.uk") }
  let(:project) { create(:project) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)

    create(:contact, project: project)
  end

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

  private def expect_page_to_have_contact(name:, title:, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email
    expect(page).to have_content(phone) if phone
  end
end

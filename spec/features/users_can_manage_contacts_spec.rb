require "rails_helper"

RSpec.feature "Users can manage contacts" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let!(:contact) { create(:contact, project: project) }
  let(:user) { create(:user) }
  let(:project) { create(:voluntary_conversion_project) }

  scenario "they can view a projects contacts" do
    visit conversions_voluntary_project_contacts_path(project)

    expect(page).to have_content("Other contacts")

    expect_page_to_have_contact(
      name: "Jo Example",
      organisation_name: "Some Organisation",
      title: "CEO of Learning",
      email: "jo@example.com",
      phone: "01632 960123"
    )
  end

  scenario "the contact groups are in the order users might expect to use them" do
    create(:contact, category: :other, project: project)
    create(:contact, category: :school, project: project)
    create(:contact, category: :trust, project: project)
    create(:contact, category: :solicitor, project: project)
    create(:contact, category: :diocese, project: project)
    create(:contact, category: :local_authority, project: project)

    visit conversions_voluntary_project_contacts_path(project)

    order_categories = page.find_all("h3.govuk-heading-m")

    %i[
      school
      trust
      local_authority
      solicitor
      diocese
      other
    ].each_with_index do |category, index|
      expect(order_categories[index].text)
        .to eql I18n.t("contact.index.category_heading", category_name: category.to_s.humanize)
    end
  end

  scenario "they can add a new contact" do
    visit conversions_voluntary_project_contacts_path(project)

    click_link "Add contact"

    expect(page).to have_select("Contact for", selected: "Choose category")

    select "Trust", from: "Contact for"
    fill_in "Name", with: "Some One"
    fill_in "Organisation", with: "Trust Name"
    fill_in "Role", with: "Chief of Knowledge"
    fill_in "Email", with: "some@example.com"
    fill_in "Phone", with: "01632 960456"

    click_button("Add contact")

    expect(page).to have_content("Trust contacts")

    expect_page_to_have_contact(
      name: "Some One",
      title: "Chief of Knowledge",
      organisation_name: "Trust Name",
      email: "some@example.com",
      phone: "01632 960456"
    )
  end

  scenario "they can delete a contact" do
    visit conversions_voluntary_project_contacts_path(project)
    expect(page).to have_content("Other contacts")

    expect_page_to_have_contact(
      name: "Jo Example",
      title: "CEO of Learning",
      email: "jo@example.com",
      phone: "01632 960123"
    )

    click_link "Change"

    click_link("Delete")

    expect(page).to have_content("Are you sure you want to delete Jo Example?")
    expect(page).to have_content("This will remove the contact for CEO of Learning called Jo Example from the contacts list.")

    click_button("Delete")

    expect(page).to have_content("There are not any contacts for this project yet.")
  end

  private def expect_page_to_have_contact(name:, title:, organisation_name: nil, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(organisation_name) if organisation_name
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email
    expect(page).to have_content(phone) if phone
  end
end

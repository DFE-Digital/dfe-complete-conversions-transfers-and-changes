require "rails_helper"

RSpec.feature "Users can manage contacts" do
  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }
  let!(:project) { create(:conversion_project) }
  let!(:contact) { create(:project_contact, project: project) }

  scenario "they can view a projects contacts" do
    visit project_contacts_path(project)

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
    create(:project_contact, category: :other, project: project)
    create(:project_contact, category: :school_or_academy, project: project)
    create(:project_contact, category: :incoming_trust, project: project)
    create(:project_contact, category: :outgoing_trust, project: project)
    create(:project_contact, category: :solicitor, project: project)
    create(:project_contact, category: :diocese, project: project)
    create(:project_contact, category: :local_authority, project: project)

    visit project_contacts_path(project)

    order_categories = page.find_all("h3.govuk-heading-m")

    %i[
      school_or_academy
      incoming_trust
      outgoing_trust
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
    visit project_contacts_path(project)

    click_link "Add contact"

    expect(page).to have_select("Contact for", selected: "Choose category")

    select "Incoming trust", from: "Contact for"
    fill_in "Name", with: "Some One"
    fill_in "Organisation", with: "Trust Name"
    fill_in "Role", with: "Chief of Knowledge"
    fill_in "Email", with: "some@example.com"
    fill_in "Phone", with: "01632 960456"

    click_button("Add contact")

    expect(page).to have_content("Incoming trust contacts")

    expect_page_to_have_contact(
      name: "Some One",
      title: "Chief of Knowledge",
      organisation_name: "Trust Name",
      email: "some@example.com",
      phone: "01632 960456"
    )
  end

  scenario "they can delete a contact" do
    visit project_contacts_path(project)
    expect(page).to have_content("Other contacts")

    expect_page_to_have_contact(
      name: "Jo Example",
      title: "CEO of Learning",
      email: "jo@example.com",
      phone: "01632 960123"
    )

    click_link "Edit"

    click_link("Delete")

    expect(page).to have_content("Are you sure you want to delete Jo Example?")
    expect(page).to have_content("This will remove the contact for CEO of Learning called Jo Example from the contacts list.")

    click_button("Delete")

    expect(page).to have_content("There are not any contacts for this project yet.")
  end

  scenario "if a contact is the main contact, it is indicated on the contact" do
    project.update!(main_contact_id: contact.id)

    visit project_contacts_path(project)
    expect(page).to have_content(I18n.t("contact.details.main_contact"))
  end

  scenario "they can create a new contact and set it as the establishment main contact" do
    visit project_contacts_path(project)

    click_link "Add contact"

    expect(page).to have_select("Contact for", selected: "Choose category")

    select "School or academy", from: "Contact for"
    fill_in "Name", with: "Some One"
    fill_in "Organisation", with: "Trust Name"
    fill_in "Role", with: "Chief of Knowledge"
    fill_in "Email", with: "some@example.com"
    check "contact_create_project_contact_form[primary_contact_for_category]"

    click_button("Add contact")

    expect(page).to have_content("School or academy contacts")
    expect(page).to have_content(I18n.t("contact.details.establishment_main_contact"))
  end

  scenario "they can edit a contact and set it to be the establishment main contact" do
    contact = create(:project_contact, project: project, category: "school_or_academy")

    visit edit_project_contact_path(project, contact)
    check "contact_create_project_contact_form[primary_contact_for_category]"

    click_button("Save contact")

    expect(project.reload.establishment_main_contact_id).to eq(contact.id)
    expect(page).to have_content(I18n.t("contact.details.establishment_main_contact"))
  end

  scenario "they can create a new contact and set it as the incoming trust main contact" do
    visit project_contacts_path(project)

    click_link "Add contact"

    select "Incoming trust", from: "Contact for"
    fill_in "Name", with: "Some One"
    fill_in "Organisation", with: "Trust Name"
    fill_in "Role", with: "Chief of Knowledge"
    fill_in "Email", with: "some@example.com"
    check "contact_create_project_contact_form[primary_contact_for_category]"

    click_button("Add contact")

    expect(page).to have_content("Incoming trust contacts")
    expect(page).to have_content(I18n.t("contact.details.incoming_trust_main_contact"))
  end

  scenario "they can create a new contact and set it as the outgoing trust main contact" do
    visit project_contacts_path(project)

    click_link "Add contact"

    select "Outgoing trust", from: "Contact for"
    fill_in "Name", with: "Some One"
    fill_in "Organisation", with: "Trust Name"
    fill_in "Role", with: "Chief of Knowledge"
    fill_in "Email", with: "some@example.com"
    check "contact_create_project_contact_form[primary_contact_for_category]"

    click_button("Add contact")

    expect(page).to have_content("Outgoing trust contacts")
    expect(page).to have_content(I18n.t("contact.details.outgoing_trust_main_contact"))
  end

  private def expect_page_to_have_contact(name:, title:, organisation_name: nil, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(organisation_name) if organisation_name
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email
    expect(page).to have_content(phone) if phone
  end
end

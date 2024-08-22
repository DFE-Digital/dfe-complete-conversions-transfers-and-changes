require "rails_helper"

RSpec.feature "Users can manage contacts" do
  before do
    mock_successful_api_response_to_create_any_project
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
    create(:project_contact, category: :solicitor, project: project)
    create(:project_contact, category: :diocese, project: project)
    create(:project_contact, category: :local_authority, project: project)

    visit project_contacts_path(project)

    order_categories = page.find_all("h3.govuk-heading-m")

    expect(order_categories[0].text).to eql(I18n.t("contact.index.category_heading", category_name: project.establishment.name))
    expect(order_categories[1].text).to eql(I18n.t("contact.index.category_heading", category_name: project.incoming_trust.name))
    expect(order_categories[2].text).to eql(I18n.t("contact.index.category_heading", category_name: project.local_authority.name))
    expect(order_categories[3].text).to eql("Solicitor contacts")
    expect(order_categories[4].text).to eql("Diocese contacts")
    expect(order_categories[5].text).to eql("Other contacts")
  end

  context "adding a new headteacher" do
    scenario "a headteacher is added with the required defaults" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Headteacher"
      click_on "Save and continue"
      expect(page).to have_content "Enter contact details"

      fill_in "Full name", with: "Jane Headteacher"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"

      click_on "Save and continue"

      expect(page).to have_content("#{project.establishment.name} contacts")

      expect_page_to_have_contact(
        name: "Jane Headteacher",
        title: "Headteacher",
        email: "some@example.com",
        phone: "01632 960456"
      )
    end

    scenario "they can set the contact as the establishment main contact" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Headteacher"
      click_on "Save and continue"

      fill_in "Full name", with: "Jane Headteacher"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"
      within "#primary-contact-for-category" do
        choose "Yes"
      end

      click_on "Save and continue"

      expect(page).to have_content("#{project.establishment.name} contacts")
      expect(page).to have_content(I18n.t("contact.details.primary_contact"))
    end
  end

  context "adding a new incoming trust CEO" do
    scenario "a CEO is added with the required defaults" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Incoming trust CEO (Chief executive officer)"
      click_on "Save and continue"
      expect(page).to have_content "Enter contact details"

      fill_in "Full name", with: "Jane Finance"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"

      click_on "Save and continue"

      expect(page).to have_content("#{project.incoming_trust.name} contacts")

      expect_page_to_have_contact(
        name: "Jane Finance",
        title: "CEO",
        email: "some@example.com",
        phone: "01632 960456"
      )
    end
  end

  context "adding a new outgoing trust CEO" do
    let!(:project) { create(:transfer_project) }

    scenario "a CEO is added with the required defaults" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Outgoing trust CEO (Chief executive officer)"
      click_on "Save and continue"
      expect(page).to have_content "Enter contact details"

      fill_in "Full name", with: "Bob Finance"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"

      click_on "Save and continue"

      expect(page).to have_content("#{project.outgoing_trust.name} contacts")

      expect_page_to_have_contact(
        name: "Bob Finance",
        title: "CEO",
        email: "some@example.com",
        phone: "01632 960456"
      )
    end

    scenario "they can set the contact as the outgoing trust main contact" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Outgoing trust CEO (Chief executive officer)"
      click_on "Save and continue"

      fill_in "Full name", with: "Bob Finance"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"
      within "#primary-contact-for-category" do
        choose "Yes"
      end

      click_on "Save and continue"

      expect(page).to have_content("#{project.outgoing_trust.name} contacts")
      expect(page).to have_content(I18n.t("contact.details.primary_contact"))
    end
  end

  context "adding a new chair of governors" do
    scenario "a chair of governors is added with the required defaults" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Chair of governors"
      click_on "Save and continue"
      expect(page).to have_content "Enter contact details"

      fill_in "Full name", with: "Susan Chair"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"

      click_on "Save and continue"

      expect(page).to have_content("#{project.establishment.name} contacts")

      expect_page_to_have_contact(
        name: "Susan Chair",
        title: "Chair of governors",
        organisation_name: project.establishment.name.to_s,
        email: "some@example.com",
        phone: "01632 960456"
      )
    end
  end

  context "adding a new other type of contact" do
    scenario "another contact type allows the user to add role and organisation name" do
      visit project_contacts_path(project)

      click_link "Add contact"
      choose "Someone else"
      click_on "Save and continue"
      expect(page).to have_content "Enter contact details"

      fill_in "Full name", with: "Frank Random"
      fill_in "Role", with: "Secretary"
      fill_in "Email", with: "some@example.com"
      fill_in "Phone", with: "01632 960456"
      within "#other_organisation_name" do
        fill_in "Enter the organisation this contact is for", with: "Another organisation"
      end

      click_on "Save and continue"

      expect(page).to have_content("Other contacts")

      expect_page_to_have_contact(
        name: "Frank Random",
        title: "Secretary",
        organisation_name: "Another organisation",
        email: "some@example.com",
        phone: "01632 960456"
      )
    end
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

  scenario "if a project has a member of parliament, the MP is shown" do
    member_details = Api::Persons::MemberDetails.new(first_name: "Robert", last_name: "Minister", email: "ministerr@parliament.gov.uk")

    allow_any_instance_of(Project).to receive(:member_of_parliament).and_return(member_details)

    visit project_contacts_path(project)

    expect(page).to have_content("Parliamentary contacts")
    expect(page).to have_content(member_details.name)
    expect(page).to have_content(member_details.email)
  end

  private def expect_page_to_have_contact(name:, title:, organisation_name: nil, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(organisation_name) if organisation_name
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email
    expect(page).to have_content(phone) if phone
  end
end

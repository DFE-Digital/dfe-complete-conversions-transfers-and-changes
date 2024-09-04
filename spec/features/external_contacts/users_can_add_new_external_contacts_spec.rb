require "rails_helper"

RSpec.feature "Users can add new external contacts" do
  before do
    mock_successful_api_response_to_create_any_project
    mock_successful_persons_api_client
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }
  let!(:project) { create(:conversion_project) }
  let!(:contact) { create(:project_contact, project: project) }

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

  private def expect_page_to_have_contact(name:, title:, organisation_name: nil, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(organisation_name) if organisation_name
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email
    expect(page).to have_content(phone) if phone
  end
end

require "rails_helper"

RSpec.feature "Users can view external contacts" do
  before do
    mock_successful_api_response_to_create_any_project
    mock_successful_persons_api_client
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }
  let!(:project) { create(:conversion_project) }
  let!(:contact) { create(:project_contact, project: project) }

  scenario "they can view a projects contacts" do
    visit project_contacts_path(project)

    expect(page).to have_content("Other contacts")

    expect(page).to have_content("Jo Example")
    expect(page).to have_content("Some Organisation")
    expect(page).to have_content("CEO of Learning")
    expect(page).to have_content("jo@example.com")
    expect(page).to have_content("01632 960123")
  end

  scenario "if a contact is the main contact, it is indicated on the contact" do
    project.update!(main_contact_id: contact.id)

    visit project_contacts_path(project)
    expect(page).to have_content(I18n.t("contact.details.main_contact"))
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

  scenario "if a project has a member of parliament, the MP is shown" do
    member_details = Api::Persons::MemberDetails.new({firstName: "Robert", lastName: "Minister", displayNameWithTitle: "The Right Honourable Firstname Lastname", email: "ministerr@parliament.gov.uk"}.with_indifferent_access)

    allow_any_instance_of(Project).to receive(:member_of_parliament).and_return(member_details)

    visit project_contacts_path(project)

    expect(page).to have_content("Parliamentary contacts")
    expect(page).to have_content("The Right Honourable Firstname Lastname")
    expect(page).to have_content("ministerr@parliament.gov.uk")
  end
end

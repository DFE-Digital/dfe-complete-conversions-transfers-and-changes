require "rails_helper"

RSpec.feature "Users can view contacts" do
  let(:user) { User.create!(email: "user@education.gov.uk") }
  let(:project) { create(:project) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 12345, ukprn: 10061021)
    sign_in_with_user(user)

    create(:contact, project: project)
  end

  scenario "User views contacts" do
    visit project_contacts_path(project_id)

    expect_page_to_have_contact(
      name: 'Jo Example',
      title: 'CEO of Learning',
      email: 'jo@example.com',
      phone: '01632 960123'
    )
  end

  private def expect_page_to_have_contact(name:, title:, email: nil, phone: nil)
    expect(page).to have_content(name)
    expect(page).to have_content(title)
    expect(page).to have_content(email) if email 
    expect(page).to have_content(phone) if phone 
  end
end

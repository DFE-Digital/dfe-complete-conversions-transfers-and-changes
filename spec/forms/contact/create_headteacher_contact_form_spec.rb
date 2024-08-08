require "rails_helper"

RSpec.describe Contact::CreateHeadteacherContactForm do
  let(:project) { create(:conversion_project) }

  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "new contact" do
    it "creates a new contact with the required defaults" do
      contact = Contact::Project.new
      contact_form = Contact::CreateHeadteacherContactForm.new(contact: contact, project: project)
      contact_form.name = "Jane Headteacher"
      contact_form.email = "a.name@domain.com"

      contact_form.save

      expect(Contact::Project.count).to eql 1

      expect(contact.name).to eql("Jane Headteacher")
      expect(contact.email).to eql("a.name@domain.com")
      expect(contact.title).to eql("Headteacher")
      expect(contact.category).to eql("school_or_academy")
      expect(contact.organisation_name).to eql(project.establishment.name)
    end
  end
end

require "rails_helper"

RSpec.describe Contact::CreateIncomingTrustCeoContactForm do
  let(:project) { create(:conversion_project) }

  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "new contact" do
    it "creates a new contact with the required defaults" do
      contact = Contact::Project.new
      contact_form = Contact::CreateIncomingTrustCeoContactForm.new(contact: contact, project: project)
      contact_form.name = "Jane Smith"
      contact_form.email = "a.name@domain.com"

      contact_form.save

      expect(Contact::Project.count).to eql 1

      expect(contact.name).to eql("Jane Smith")
      expect(contact.email).to eql("a.name@domain.com")
      expect(contact.title).to eql("CEO")
      expect(contact.category).to eql("incoming_trust")
      expect(contact.organisation_name).to eql(project.incoming_trust.name)
    end
  end
end

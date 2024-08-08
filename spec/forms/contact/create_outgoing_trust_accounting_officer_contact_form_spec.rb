require "rails_helper"

RSpec.describe Contact::CreateOutgoingTrustCeoContactForm do
  let(:project) { create(:transfer_project) }

  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "new contact" do
    it "creates a new contact with the required defaults" do
      contact = Contact::Project.new
      contact_form = Contact::CreateOutgoingTrustCeoContactForm.new(contact: contact, project: project)
      contact_form.name = "Jane Smith"
      contact_form.email = "a.name@domain.com"

      contact_form.save

      expect(Contact::Project.count).to eql 1

      expect(contact.name).to eql("Jane Smith")
      expect(contact.email).to eql("a.name@domain.com")
      expect(contact.title).to eql("CEO")
      expect(contact.category).to eql("outgoing_trust")
      expect(contact.organisation_name).to eql(project.outgoing_trust.name)
    end

    context "when the project does not have an outgoing trust" do
      let(:project) { create(:conversion_project) }

      it "adds a validation error" do
        contact = Contact::Project.new
        contact_form = Contact::CreateOutgoingTrustCeoContactForm.new(contact: contact, project: project)
        contact_form.name = "Jane Ceo"
        contact_form.email = "a.name@domain.com"

        expect(contact_form.valid?).to be false
        expect(contact_form.errors[:base]).to include("The selected category type is not supported by this project type")
      end
    end
  end
end

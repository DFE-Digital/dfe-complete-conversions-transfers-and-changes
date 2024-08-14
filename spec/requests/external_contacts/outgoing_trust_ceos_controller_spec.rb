require "rails_helper"

RSpec.describe ExternalContacts::OutgoingTrustCeosController, type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10059062)
  end

  describe "#create" do
    let(:project) { create(:transfer_project) }
    let(:project_id) { project.id }
    let(:contact_name) { "Mary Finance" }

    subject(:perform_request) do
      post project_external_contacts_outgoing_trust_ceo_path(project_id), params: {contact_create_outgoing_trust_ceo_contact_form: {name: contact_name}}
      response
    end

    it "creates a CEO contact successfully" do
      expect(subject).to redirect_to(project_contacts_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("contact.create.success"))

      expect(Contact.count).to be 1
      contact = Contact.last
      expect(contact.name).to eq("Mary Finance")
      expect(contact.organisation_name).to eq(project.outgoing_trust.name)
      expect(contact.category).to eq("outgoing_trust")
    end

    context "if the contact is invalid" do
      let(:contact_name) { nil }

      it "re-renders the page and shows errors" do
        expect(perform_request).to render_template :new
        expect(subject.body).to include("There is a problem")
      end
    end
  end
end

require "rails_helper"

RSpec.describe ExternalContacts::IncomingTrustCeosController, type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: any_args, ukprn: 10061021)
  end

  describe "#create" do
    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }
    let(:contact_name) { "Frank Finance" }

    subject(:perform_request) do
      post project_external_contacts_incoming_trust_ceo_path(project_id), params: {contact_create_incoming_trust_ceo_contact_form: {name: contact_name}}
      response
    end

    it "creates a CEO contact successfully" do
      expect(subject).to redirect_to(project_contacts_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("contact.create.success"))

      expect(Contact.count).to be 1
      contact = Contact.last
      expect(contact.name).to eq("Frank Finance")
      expect(contact.organisation_name).to eq(project.incoming_trust.name)
      expect(contact.category).to eq("incoming_trust")
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

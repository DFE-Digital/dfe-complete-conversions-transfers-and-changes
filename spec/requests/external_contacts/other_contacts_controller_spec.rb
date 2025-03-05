require "rails_helper"

RSpec.describe ExternalContacts::OtherContactsController, type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: any_args, ukprn: 10061021)
  end

  describe "#create" do
    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }
    let(:contact_name) { "Sean Secretary" }
    let(:category) { "other" }
    let(:organisation_name) { "Another organisation" }

    subject(:perform_request) do
      post project_external_contacts_other_contact_path(project_id), params: {contact_create_project_contact_form: {name: contact_name, organisation_name: organisation_name, category: category, title: "Secretary"}}
      response
    end

    it "creates a 'other' contact successfully" do
      expect(subject).to redirect_to(project_contacts_path(project))
      expect(request.flash[:notice]).to eq(I18n.t("contact.create.success"))

      expect(Contact.count).to be 1
      contact = Contact.last
      expect(contact.name).to eq("Sean Secretary")
      expect(contact.organisation_name).to eq("Another organisation")
      expect(contact.category).to eq("other")
    end

    context "if the category is one of school_or_academy, incoming/outgoing trust or local authority" do
      let(:category) { "school_or_academy" }
      let(:organisation_name) { nil }

      it "sets the organisation name automatically to the relevant entity" do
        expect(subject).to redirect_to(project_contacts_path(project))
        expect(request.flash[:notice]).to eq(I18n.t("contact.create.success"))

        expect(Contact.count).to be 1
        contact = Contact.last
        expect(contact.name).to eq("Sean Secretary")
        expect(contact.organisation_name).to eq(project.establishment.name)
        expect(contact.category).to eq("school_or_academy")
      end
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

require "rails_helper"

RSpec.describe ExternalContactsController, type: :request do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: any_args, ukprn: 10061021)
    mock_successful_persons_api_client
  end

  describe "#index" do
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_contacts_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end

    context "when the project has a director of child services" do
      it "includes the director of child services in the response" do
        director_of_child_services_contact = create(:director_of_child_services)
        allow_any_instance_of(Project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)

        get project_contacts_path(project)

        expect(response.body).to include(director_of_child_services_contact.name)
      end
    end
  end

  describe "#new" do
    let(:project_id) { project.id }

    subject(:perform_request) do
      get new_project_contact_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#create" do
    let(:project_id) { project.id }
    let(:mock_contact) { build(:project_contact) }
    let(:contact_type) { "headteacher" }

    subject(:perform_request) do
      post project_contacts_path(project_id), params: {new_conversion_contact_form: {contact_type: contact_type}}
      response
    end

    it "renders the Headteacher page" do
      expect(subject).to have_http_status :success
      expect(subject.body).to include "Check the contact details you have for the headteacher against GIAS (Get information about schools). You can edit these details later if you need to."
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the contact type is not recognised" do
      let(:contact_type) { "government" }

      it "returns not found" do
        expect(subject).to have_http_status :not_found
      end
    end
  end

  describe "#edit" do
    let(:project_id) { project.id }
    let(:contact) { create(:project_contact, project: project) }
    let(:contact_id) { contact.id }

    subject(:perform_request) do
      get edit_project_contact_path(project_id, contact_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Contact is not found" do
      let(:contact_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#update" do
    let(:project_id) { project.id }
    let(:contact) { create(:project_contact, project: project) }
    let(:contact_id) { contact.id }
    let(:new_contact_name) { "Josephine Bloggs" }
    let(:new_contact_title) { "Headteacher" }

    subject(:perform_request) do
      put project_contact_path(project_id, contact_id), params: {contact_create_project_contact_form: {name: new_contact_name, title: new_contact_title, category: "school_or_academy"}}
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Contact is not found" do
      let(:contact_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the contact is invalid" do
      before do
        allow(Contact).to receive(:find).and_return(contact)
        allow(contact).to receive(:valid?).and_return false
      end

      it "renders the edit template" do
        expect(perform_request).to render_template :edit
      end
    end

    context "when the contact is valid" do
      it "saves the contact and redirects to the index view with a success message" do
        expect(subject).to redirect_to(project_contacts_path(project.id))
        expect(request.flash[:notice]).to eq(I18n.t("contact.update.success"))

        expect(Contact.count).to be 1
        expect(Contact.last.name).to eq(new_contact_name)
        expect(Contact.last.title).to eq(new_contact_title)
      end
    end
  end

  describe "#destroy" do
    let(:project_id) { project.id }
    let(:contact) { create(:project_contact) }
    let(:contact_id) { contact.id }

    subject(:perform_request) do
      delete project_contact_path(project_id, contact_id)
      response
    end

    it "deletes the contact and redirects to the index view with a success message" do
      expect(perform_request).to redirect_to(project_contacts_path(project.id))
      expect(request.flash[:notice]).to eq(I18n.t("contact.destroy.success"))

      expect(Contact.where(id: contact_id)).to_not exist
    end
  end

  describe "#confirm_destroy" do
    let(:project_id) { project.id }
    let(:contact) { create(:project_contact) }
    let(:contact_id) { contact.id }

    subject(:perform_request) do
      get project_contact_delete_path(project_id, contact_id)
      response
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end
end

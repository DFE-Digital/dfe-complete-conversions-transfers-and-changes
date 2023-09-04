require "rails_helper"

RSpec.describe Contact::CreateProjectContactForm do
  let(:project) { create(:conversion_project) }

  before do
    mock_successful_api_response_to_create_any_project
  end

  context "a new contact" do
    context "when the establishment_main_contact box is NOT checked" do
      it "is valid" do
        contact_form = Contact::CreateProjectContactForm.new({}, project)
        contact_form.establishment_main_contact = "0"
        expect(contact_form).to be_valid
      end
    end

    context "when the establishment_main_contact box is checked" do
      context "when the contact category is school" do
        it "is valid" do
          contact_form = Contact::CreateProjectContactForm.new({}, project)
          contact_form.establishment_main_contact = "1"
          contact_form.category = "school"
          expect(contact_form).to be_valid
        end

        it "marks the contact as the establishment main contact on the project" do
          contact_form = Contact::CreateProjectContactForm.new({}, project)
          contact_form.establishment_main_contact = "1"
          contact_form.category = "school"
          contact_form.name = "New Contact"
          contact_form.title = "Financial Controller"
          contact_form.organisation_name = "School"
          contact_form.save
          contact = Contact::Project.last
          expect(project.reload.establishment_main_contact).to eq(contact)
        end
      end

      context "when the contact category is NOT school" do
        it "is not valid" do
          contact_form = Contact::CreateProjectContactForm.new({}, project)
          contact_form.establishment_main_contact = "1"
          contact_form.category = "incoming_trust"
          expect(contact_form).to_not be_valid
        end
      end
    end

    context "when something fails in the transaction" do
      before do
        allow_any_instance_of(Contact::Project).to receive(:save).and_return(ActiveRecord::ActiveRecordError)
      end

      it "does not create the contact" do
        contact_form = Contact::CreateProjectContactForm.new({}, project)
        contact_form.category = "school"
        contact_form.name = "New Contact"
        contact_form.title = "Financial Controller"
        contact_form.organisation_name = "School"
        contact_form.save

        expect(Contact::Project.count).to eq(0)
      end
    end
  end

  context "editing a contact" do
    let(:contact) { create(:project_contact, project: project) }

    context "when the establishment_main_contact box is NOT checked" do
      it "is valid" do
        contact_form = Contact::CreateProjectContactForm.new_from_contact(project, contact)
        contact_form.establishment_main_contact = "0"
        expect(contact_form).to be_valid
      end

      it "updates the existing contact" do
        contact_form = Contact::CreateProjectContactForm.new_from_contact(project, contact)
        contact_form.establishment_main_contact = "0"
        contact_form.name = "New Name"
        contact_form.save
        expect(contact.reload.name).to eq("New Name")
      end
    end

    context "when the establishment_main_contact box is checked" do
      context "when the contact category is school" do
        let(:contact) { create(:project_contact, project: project, category: "school") }

        it "is valid" do
          contact_form = Contact::CreateProjectContactForm.new_from_contact(project, contact)
          contact_form.establishment_main_contact = "1"
          expect(contact_form).to be_valid
        end

        it "updates the existing contact" do
          contact_form = Contact::CreateProjectContactForm.new_from_contact(project, contact)
          contact_form.establishment_main_contact = "1"
          contact_form.name = "New Name"
          contact_form.save
          expect(contact.reload.name).to eq("New Name")
        end
      end

      context "when the contact category is NOT school" do
        let(:contact) { create(:project_contact, project: project, category: "solicitor") }

        it "is not valid" do
          contact_form = Contact::CreateProjectContactForm.new_from_contact(project, contact)
          contact_form.establishment_main_contact = "1"
          expect(contact_form).to_not be_valid
        end
      end
    end
  end
end

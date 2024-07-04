require "rails_helper"

RSpec.describe Contact::CreateProjectContactForm do
  let(:project) { create(:conversion_project, establishment_main_contact: nil, incoming_trust_main_contact: nil, outgoing_trust_main_contact: nil) }

  before do
    mock_successful_api_response_to_create_any_project
  end

  describe "new contact" do
    it "can add them" do
      contact = Contact::Project.new
      contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
      contact_form.name = "Adifferent Name"
      contact_form.email = "a.name@domain.com"
      contact_form.category = "school_or_academy"
      contact_form.title = "Role"

      contact_form.save

      expect(Contact::Project.count).to eql 1

      expect(contact.name).to eql("Adifferent Name")
      expect(contact.email).to eql("a.name@domain.com")
    end
  end

  describe "existing contact" do
    it "can update them" do
      contact = create(:project_contact, project: project, category: "school_or_academy")
      contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
      contact_form.name = "Adifferent Name"
      contact_form.email = "a.name@domain.com"

      contact_form.save

      expect(contact.reload.name).to eql("Adifferent Name")
      expect(contact.reload.email).to eql("a.name@domain.com")
    end
  end

  describe "the primary contact" do
    context "when adding a new contact" do
      let(:contact_form) { Contact::CreateProjectContactForm.new(contact: Contact::Project.new, project: project) }

      context "when the primary contact box is checked" do
        before { contact_form.primary_contact_for_category = false }

        context "and the cateogry is school or academy" do
          it "is valid" do
            contact_form.category = "school_or_academy"

            expect(contact_form).to be_valid
          end

          it "sets the contact as the establishment main contact" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "school_or_academy"
            contact_form.name = "New Contact"
            contact_form.title = "Financial Controller"
            contact_form.organisation_name = "School"

            contact_form.save
            contact = Contact::Project.last

            expect(project.reload.establishment_main_contact).to eq(contact)
            expect(project.establishment_main_contact.name).to eql("New Contact")
          end
        end

        context "and the category is incoming trust" do
          it "is valid" do
            contact_form.category = "incoming_trust"

            expect(contact_form).to be_valid
          end

          it "sets the contact as the incoming trust main contact" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "incoming_trust"
            contact_form.name = "New Contact"
            contact_form.title = "Financial Controller"
            contact_form.organisation_name = "School"

            contact_form.save
            contact = Contact::Project.last

            expect(project.reload.incoming_trust_main_contact).to eq(contact)
          end
        end

        context "and the category is outgoing trust" do
          it "is valid" do
            contact_form.category = "outgoing_trust"

            expect(contact_form).to be_valid
          end

          it "sets the contact as the outgoing trust main contact" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "outgoing_trust"
            contact_form.name = "New Contact"
            contact_form.title = "Financial Controller"
            contact_form.organisation_name = "School"

            contact_form.save
            contact = Contact::Project.last

            expect(project.reload.outgoing_trust_main_contact).to eq(contact)
          end
        end

        context "and the category is local authority" do
          it "is valid" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "local_authority"

            expect(contact_form).to be_valid
          end

          it "sets the contact as the local authority main contact" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "local_authority"
            contact_form.name = "New Contact"
            contact_form.title = "Local councillor"
            contact_form.organisation_name = "Council"

            contact_form.save
            contact = Contact::Project.last

            expect(project.reload.local_authority_main_contact).to eq(contact)
          end
        end

        context "and the category is diocese" do
          it "is invalid" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "diocese"

            expect(contact_form).to be_invalid
          end
        end

        context "and the category is solicitor" do
          it "is invalid" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "solicitor"

            expect(contact_form).to be_invalid
          end
        end

        context "and the category is other" do
          it "is invalid" do
            contact_form.primary_contact_for_category = true
            contact_form.category = "other"

            expect(contact_form).to be_invalid
          end
        end
      end

      context "when something fails in the transaction" do
        it "does not create the contact" do
          contact = Contact::Project.new

          allow(project).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)

          contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
          contact_form.category = "school_or_academy"
          contact_form.name = "New Contact"
          contact_form.title = "Financial Controller"
          contact_form.organisation_name = "School"

          expect { contact_form.save }.to raise_error(ActiveRecord::RecordInvalid)
          expect(Contact::Project.count).to be_zero
        end
      end
    end

    context "when editing a contact" do
      context "and the category is one that does support a primary contact" do
        let(:contact) { create(:project_contact, project: project, category: "school_or_academy") }

        it "updates the contact details" do
          contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
          contact_form.name = "Adifferent Name"
          contact_form.email = "a.name@domain.com"

          contact_form.save

          expect(contact.reload.name).to eql("Adifferent Name")
          expect(contact.reload.email).to eql("a.name@domain.com")
        end
      end

      context "when the category is one that does not support a primary contact" do
        let(:contact) { create(:project_contact, project: project, category: "other") }

        it "is invalid" do
          contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
          contact_form.primary_contact_for_category = true

          expect(contact_form).to be_invalid
        end
      end

      context "when the existing contact is not the primary contact" do
        let(:contact) { create(:project_contact, project: project, category: "school_or_academy") }

        it "can be set" do
          contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
          contact_form.primary_contact_for_category = true

          expect(project.establishment_main_contact_id).to be_nil

          contact_form.save

          expect(project.establishment_main_contact_id).to eql(contact.id)
        end
      end

      context "when the exisiting contact is the primary contact" do
        context "and the contact is for the school or academy category" do
          let(:contact) { create(:project_contact, project: project, category: "school_or_academy") }

          it "can be unset" do
            project.update!(establishment_main_contact_id: contact.id)
            contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
            contact_form.primary_contact_for_category = false

            expect(project.establishment_main_contact_id).to eql(contact.id)

            contact_form.save

            expect(project.establishment_main_contact_id).to be_nil
          end
        end

        context "and the contact is for the incoming trust category" do
          let(:contact) { create(:project_contact, project: project, category: "incoming_trust") }

          it "can be unset" do
            project.update!(incoming_trust_main_contact_id: contact.id)
            contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
            contact_form.primary_contact_for_category = false

            expect(project.incoming_trust_main_contact_id).to eql(contact.id)

            contact_form.save

            expect(project.incoming_trust_main_contact_id).to be_nil
          end
        end

        context "and the contact is for the outgoing trust category" do
          let(:contact) { create(:project_contact, project: project, category: "outgoing_trust") }

          it "can be unset" do
            project.update!(outgoing_trust_main_contact_id: contact.id)
            contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
            contact_form.primary_contact_for_category = false

            expect(project.outgoing_trust_main_contact_id).to eql(contact.id)

            contact_form.save

            expect(project.outgoing_trust_main_contact_id).to be_nil
          end
        end

        context "and the contact is for the local authority category" do
          let(:contact) { create(:project_contact, project: project, category: "local_authority") }

          it "can be unset" do
            project.update!(local_authority_main_contact_id: contact.id)
            contact_form = Contact::CreateProjectContactForm.new(contact: contact, project: project)
            contact_form.primary_contact_for_category = false

            expect(project.local_authority_main_contact_id).to eql(contact.id)

            contact_form.save

            expect(project.local_authority_main_contact_id).to be_nil
          end
        end
      end
    end
  end
end

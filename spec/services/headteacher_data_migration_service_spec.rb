require "rails_helper"

RSpec.describe HeadteacherDataMigrationService do
  before { mock_all_academies_api_responses }

  context "when there are establishment contacts for a project" do
    it "copies the contact to a new project contact" do
      project = create(:conversion_project)
      first_establishment_contact = create(
        :establishment_contact,
        name: "First Contact",
        email: "f.contact@establishment.ac.uk",
        establishment_urn: project.urn
      )
      last_establishment_contact = create(
        :establishment_contact,
        name: "Last Contact",
        email: "l.contact@establishment.ac.uk",
        establishment_urn: project.urn
      )

      expect { described_class.new.migrate! }.to change { Contact::Project.count }.by(2)

      first_project_contact = project.contacts.find_by_email "f.contact@establishment.ac.uk"

      expect(first_project_contact.name).to eql first_establishment_contact.name
      expect(first_project_contact.title).to eql first_establishment_contact.title
      expect(first_project_contact.email).to eql first_establishment_contact.email
      expect(first_project_contact.phone).to eql first_establishment_contact.phone
      expect(first_project_contact.organisation_name).to eql project.establishment.name
      expect(first_project_contact.category).to eql "school_or_academy"

      last_project_contact = project.contacts.find_by_email "l.contact@establishment.ac.uk"

      expect(last_project_contact.name).to eql last_establishment_contact.name
    end
  end

  context "when there are no establishment contacts for a project" do
    it "does nothing" do
      project = create(:conversion_project)

      expect { described_class.new.migrate! }.not_to change { Contact::Project.count }
      expect { described_class.new.migrate! }.to output("No establishment contacts for project #{project.id}\n").to_stdout
    end
  end
end

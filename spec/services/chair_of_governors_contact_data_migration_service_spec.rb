require "rails_helper"

RSpec.describe ChairOfGovernorsContactDataMigrationService do
  before do
    mock_all_academies_api_responses
  end

  let!(:project) { create(:conversion_project) }
  let!(:chair_of_governors) { create(:project_contact, project: project) }

  it "copies the chair of governors if there is one" do
    project.update(chair_of_governors_contact_id: chair_of_governors.id)

    expect(project.key_contacts).to be_nil

    described_class.new.migrate!

    expect(project.reload.key_contacts.chair_of_governors).to eql chair_of_governors
  end

  it "does nothing if there is no chair of governors" do
    described_class.new.migrate!

    expect(project.reload.key_contacts).to be_nil
  end

  it "works when there is already a key contacts" do
    key_contacts = KeyContacts.create
    project.update(chair_of_governors_contact_id: chair_of_governors.id, key_contacts: key_contacts)

    described_class.new.migrate!

    expect(project.reload.key_contacts.chair_of_governors).to eql chair_of_governors
  end

  it "creates key contacts as required" do
    project.update(chair_of_governors_contact_id: chair_of_governors.id)

    expect(project.key_contacts).to be_nil

    described_class.new.migrate!

    expect(project.reload.key_contacts).to be_present
  end
end

require "rails_helper"
RSpec.describe Contact::Project do
  describe "Relationships" do
    it { is_expected.to belong_to(:project) }
  end

  describe "#establishment_main_contact" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    it "returns true if the contact is the establishment_main_contact for its project" do
      project = create(:conversion_project)
      contact = create(:project_contact, project: project)
      project.establishment_main_contact_id = contact.id
      project.save

      expect(contact.reload.establishment_main_contact).to be true
    end

    it "returns false if the contact is NOT the establishment_main_contact for its project" do
      project = create(:conversion_project, establishment_main_contact_id: SecureRandom.uuid)
      contact = create(:project_contact, project: project)

      expect(contact.establishment_main_contact).to be false
    end
  end

  describe "#incoming_trust_main_contact" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    it "returns true if the contact is the incoming_trust_main_contact for its project" do
      project = create(:conversion_project)
      contact = create(:project_contact, project: project)
      project.incoming_trust_main_contact_id = contact.id
      project.save

      expect(contact.reload.incoming_trust_main_contact).to be true
    end

    it "returns false if the contact is NOT the incoming_trust_main_contact for its project" do
      project = create(:conversion_project, incoming_trust_main_contact_id: SecureRandom.uuid)
      contact = create(:project_contact, project: project)

      expect(contact.incoming_trust_main_contact).to be false
    end
  end

  describe "#outgoing_trust_main_contact" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    it "returns true if the contact is the outgoing_trust_main_contact for its project" do
      project = create(:conversion_project)
      contact = create(:project_contact, project: project)
      project.outgoing_trust_main_contact_id = contact.id
      project.save

      expect(contact.reload.outgoing_trust_main_contact).to be true
    end

    it "returns false if the contact is NOT the outgoing_trust_main_contact for its project" do
      project = create(:conversion_project, outgoing_trust_main_contact_id: SecureRandom.uuid)
      contact = create(:project_contact, project: project)

      expect(contact.outgoing_trust_main_contact).to be false
    end
  end

  describe "#local_authority_main_contact" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    it "returns true if the contact is the local_authority_main_contact for its project" do
      project = create(:conversion_project)
      contact = create(:project_contact, project: project)
      project.local_authority_main_contact_id = contact.id
      project.save

      expect(contact.reload.local_authority_main_contact).to be true
    end

    it "returns false if the contact is NOT the local_authority_main_contact for its project" do
      project = create(:conversion_project, local_authority_main_contact_id: SecureRandom.uuid)
      contact = create(:project_contact, project: project)

      expect(contact.local_authority_main_contact).to be false
    end
  end
end

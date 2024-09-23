require "rails_helper"

RSpec.describe ContactsFetcherService do
  before { mock_all_academies_api_responses }
  let(:project) { create(:transfer_project) }

  describe "#director_of_child_services" do
    it "returns the contact when there is one" do
      director_of_child_services_contact = create(:director_of_child_services)
      allow(project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)

      result = described_class.new(project)

      expect(result.director_of_child_services).to eql(director_of_child_services_contact)
    end

    it "returns nil when there is not one" do
      allow(project).to receive(:director_of_child_services).and_return(nil)

      result = described_class.new(project)

      expect(result.director_of_child_services).to be_nil
    end
  end

  describe "#all_project_contacts" do
    it "returns the contacts for a given project in name order" do
      project_contact = create(:project_contact, project: project, name: "Ann Altman")

      director_of_child_services_contact = create(:director_of_child_services, name: "Bob Brown")
      allow(project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)

      result = described_class.new(project).all_project_contacts

      expect(result.count).to eql(2)
      expect(result.first).to eq(project_contact)
      expect(result[1]).to eq(director_of_child_services_contact)
    end

    it "returns an empty array when there are no contacts" do
      result = described_class.new(project).all_project_contacts
      expect(result).to eq([])
    end
  end

  describe "#all_project_contacts_grouped" do
    it "returns the contacts for a given project in groups" do
      project_contact = create(:project_contact, project: project, category: "school_or_academy")

      director_of_child_services_contact = create(:director_of_child_services)
      allow(project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)

      result = described_class.new(project).all_project_contacts_grouped

      expect(result.count).to eql(2)
      expect(result["school_or_academy"].count).to eql(1)
      expect(result["school_or_academy"]).to include(project_contact)
      expect(result["local_authority"]).to include(director_of_child_services_contact)
    end

    context "when there are no contacts" do
      context "and there is a director of child services" do
        it "returns the director of child services contact" do
          project = create(:transfer_project)
          director_of_child_services = create(:director_of_child_services)
          allow(project).to receive(:director_of_child_services).and_return(director_of_child_services)

          result = described_class.new(project).all_project_contacts_grouped

          expect(result.values.flatten.count).to eql(1)
          expect(result.values.flatten.first).to be(director_of_child_services)
        end
      end

      context "and there is not a director of child services" do
        it "returns empty" do
          project = create(:transfer_project)
          allow(project).to receive(:director_of_child_services).and_return(nil)

          result = described_class.new(project).all_project_contacts_grouped

          expect(result).to be_empty
        end
      end
    end
  end

  describe "#outgoing_trust_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "outgoing_trust") }

    context "when there is an outgoing_trust_main_contact_id" do
      before { allow(project).to receive(:outgoing_trust_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(described_class.new(project).outgoing_trust_contact).to eq(contact)
      end
    end

    context "when there is NOT an outgoing_trust_main_contact_id" do
      before { allow(project).to receive(:outgoing_trust_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(described_class.new(project).outgoing_trust_contact).to eq(contact)
      end
    end
  end

  describe "#school_or_academy_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "school_or_academy") }

    context "when there is an establishment_main_contact_id" do
      before { allow(project).to receive(:establishment_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(described_class.new(project).school_or_academy_contact).to eq(contact)
      end
    end

    context "when there is NOT an establishment_main_contact_id" do
      before { allow(project).to receive(:establishment_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(described_class.new(project).school_or_academy_contact).to eq(contact)
      end
    end
  end

  describe "#incoming_trust_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "incoming_trust") }

    context "when there is an incoming_trust_main_contact_id" do
      before { allow(project).to receive(:incoming_trust_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(described_class.new(project).incoming_trust_contact).to eq(contact)
      end
    end

    context "when there is NOT an incoming_trust_main_contact_id" do
      before { allow(project).to receive(:incoming_trust_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(described_class.new(project).incoming_trust_contact).to eq(contact)
      end
    end
  end

  describe "#local_authority_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "local_authority") }

    context "when there is a local_authority_main_contact_id" do
      before { allow(project).to receive(:local_authority_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(described_class.new(project).local_authority_contact).to eq(contact)
      end
    end

    context "when there is NOT a local_authority_main_contact_id" do
      before { allow(project).to receive(:local_authority_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(described_class.new(project).local_authority_contact).to eq(contact)
      end
    end
  end

  describe "#other_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "other") }

    it "returns the first 'other' contact" do
      expect(described_class.new(project).other_contact).to eq(contact)
    end
  end
end

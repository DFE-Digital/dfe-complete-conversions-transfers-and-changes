require "rails_helper"

RSpec.describe ContactsFetcherService do
  before { mock_all_academies_api_responses }
  let(:project) { create(:transfer_project) }
  subject { described_class.new }

  describe "#all_project_contacts" do
    it "returns the contacts for a given project" do
      project_contact = create(:project_contact, project: project, category: "school_or_academy")

      director_of_child_services_contact = create(:director_of_child_services)
      allow(project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)

      establishment_contact = create(:establishment_contact, establishment_urn: project.urn)

      result = subject.all_project_contacts(project)

      expect(result.count).to eql(2)
      expect(result["school_or_academy"].count).to eql(2)
      expect(result["school_or_academy"]).to include(project_contact)
      expect(result["school_or_academy"]).to include(establishment_contact)
      expect(result["local_authority"]).to include(director_of_child_services_contact)
    end

    context "when there are no contacts" do
      context "and there is a director of child services" do
        it "returns the director of child services contact" do
          project = create(:transfer_project)
          director_of_child_services = create(:director_of_child_services)
          allow(project).to receive(:director_of_child_services).and_return(director_of_child_services)

          service = described_class.new
          result = service.all_project_contacts(project)

          expect(result.values.flatten.count).to eql(1)
          expect(result.values.flatten.first).to be(director_of_child_services)
        end
      end

      context "and there is an establishment contact" do
        it "returns the establishment contact" do
          project = create(:transfer_project)
          establishment_contact = create(:establishment_contact, establishment_urn: project.urn)

          service = described_class.new
          result = service.all_project_contacts(project)

          expect(result.values.flatten.count).to eql(1)
          expect(result.values.flatten.first).to eq(establishment_contact)
        end
      end

      context "and there is not a director of child services or an establishment contact" do
        it "returns empty" do
          project = create(:transfer_project)
          allow(project).to receive(:director_of_child_services).and_return(nil)

          service = described_class.new
          result = service.all_project_contacts(project)

          expect(result).to be_empty
        end
      end
    end
  end

  describe "#school_or_academy_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "school_or_academy") }

    context "when there is an establishment_main_contact_id" do
      before { allow(project).to receive(:establishment_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(subject.school_or_academy_contact(project)).to eq(contact)
      end
    end

    context "when there is NOT an establishment_main_contact_id" do
      before { allow(project).to receive(:establishment_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(subject.school_or_academy_contact(project)).to eq(contact)
      end
    end
  end

  describe "#outgoing_trust_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "outgoing_trust") }

    context "when there is an outgoing_trust_main_contact_id" do
      before { allow(project).to receive(:outgoing_trust_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(subject.outgoing_trust_contact(project)).to eq(contact)
      end
    end

    context "when there is NOT an outgoing_trust_main_contact_id" do
      before { allow(project).to receive(:outgoing_trust_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(subject.outgoing_trust_contact(project)).to eq(contact)
      end
    end
  end

  describe "#incoming_trust_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "incoming_trust") }

    context "when there is an incoming_trust_main_contact_id" do
      before { allow(project).to receive(:incoming_trust_main_contact_id).and_return(contact.id) }

      it "returns the contact with that id" do
        expect(subject.incoming_trust_contact(project)).to eq(contact)
      end
    end

    context "when there is NOT an incoming_trust_main_contact_id" do
      before { allow(project).to receive(:incoming_trust_main_contact_id).and_return(nil) }

      it "returns the next matching contact" do
        expect(subject.incoming_trust_contact(project)).to eq(contact)
      end
    end
  end

  describe "#other_contact" do
    let!(:contact) { create(:project_contact, project: project, category: "other") }

    it "returns the first 'other' contact" do
      expect(subject.other_contact(project)).to eq(contact)
    end
  end
end

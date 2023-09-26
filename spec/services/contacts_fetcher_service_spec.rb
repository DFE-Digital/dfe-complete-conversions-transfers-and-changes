require "rails_helper"

RSpec.describe ContactsFetcherService do
  before { mock_all_academies_api_responses }

  describe "#all_project_contacts" do
    it "returns the contacts for a given project" do
      project = create(:transfer_project)
      project_contact = create(:project_contact, project: project, category: "school_or_academy")
      director_of_child_services_contact = create(:director_of_child_services)
      allow(project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)

      service = described_class.new
      result = service.all_project_contacts(project)

      expect(result.count).to eql(2)
      expect(result["school_or_academy"]).to include(project_contact)
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

      context "and there is not a director of child services" do
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
end

require "rails_helper"

RSpec.describe Export::Transfers::AcademiesDueToTransferCsvExportService do
  describe "#call" do
    it "returns only the headers when there are no projects" do
      projects = []

      csv_export = described_class.new(projects).call

      expect(csv_export).to include("School URN")
      expect(csv_export).to include("Assigned to email")
    end

    it "returns a row of data" do
      mock_all_academies_api_responses
      project = build(:transfer_project)
      projects = [project]

      csv_export = described_class.new(projects).call

      expect(csv_export).to include(project.establishment.name)
      expect(csv_export).to include(project.outgoing_trust_ukprn.to_s)
      expect(csv_export).to include(project.incoming_trust_ukprn.to_s)
      expect(csv_export).to include(project.assigned_to.email)
    end
  end
end

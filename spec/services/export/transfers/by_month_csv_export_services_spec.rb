require "rails_helper"

RSpec.describe Export::Transfers::AllDataCsvExportService do
  describe "#call" do
    before do
      mock_all_academies_api_responses
      mock_successful_members_api_postcode_search_response(member_contact_details: nil, member_name: nil)
    end

    it "returns a csv with headers and values" do
      project = build(:transfer_project)
      projects = [project]

      csv_export = described_class.new(projects).call

      expect(csv_export).to include("Project type")
      expect(csv_export).to include("Outgoing trust UKPRN")

      expect(csv_export).to include("Transfer")
      expect(csv_export).to include("10059062")
    end
  end
end

require "rails_helper"

RSpec.describe Export::Conversions::AllDataCsvExportService do
  describe "#call" do
    before do
      mock_all_academies_api_responses
      mock_successful_persons_api_client
    end

    it "returns a csv with headers and values" do
      user = build(:user, first_name: "Joe", last_name: "Bloggs")
      project = build(:conversion_project, team: "south_east", assigned_to: user)
      projects = [project]

      csv_export = described_class.new(projects).call

      expect(csv_export).to include("Project created by")
      expect(csv_export).to include("Team managing the project")

      expect(csv_export).to include("Joe Bloggs")
      expect(csv_export).to include("South East")
    end
  end
end

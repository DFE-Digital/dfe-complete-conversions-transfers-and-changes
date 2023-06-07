require "rails_helper"

RSpec.describe OpeningProjectsCsvExporter do
  describe "#call" do
    before do
      mock_successful_api_response_to_create_any_project
    end

    it "returns a csv with the school urn" do
      project = build(:conversion_project, urn: 654321)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("School URN")
      expect(csv_export).to include("654321")
    end

    it "returns a csv with the DfE number" do
      establishment = build(:academies_api_establishment)
      allow(establishment).to receive(:dfe_number).and_return("765/4321")
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("DfE number")
      expect(csv_export).to include("765/4321")
    end

    it "returns a csv with the establishment name" do
      establishment = build(:academies_api_establishment)
      allow(establishment).to receive(:name).and_return("Establishment name")
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("School name")
      expect(csv_export).to include("Establishment name")
    end
  end
end

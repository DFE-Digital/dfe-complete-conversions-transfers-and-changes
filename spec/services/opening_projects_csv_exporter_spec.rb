require "rails_helper"

RSpec.describe OpeningProjectsCsvExporter do
  describe "#call" do
    before do
      mock_successful_api_response_to_create_any_project
      mock_successful_memeber_details
    end

    it "raises when there are no projects" do
      expect { OpeningProjectsCsvExporter.new([]) }.to raise_error(ArgumentError)
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

    it "returns a csv with the MP details" do
      project = build(:conversion_project)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("MP name")
      expect(csv_export).to include("MP email")
      expect(csv_export).to include("MP address 1")
      expect(csv_export).to include("MP address 2")
      expect(csv_export).to include("MP address 3")
      expect(csv_export).to include("MP postcode")

      expect(csv_export).to include("Member Parliment")
      expect(csv_export).to include("member.parliment@parliment.uk")
      expect(csv_export).to include("House of Commons")
      expect(csv_export).to include("London")
      expect(csv_export).to include("SW1A 0AA")
    end
  end
end

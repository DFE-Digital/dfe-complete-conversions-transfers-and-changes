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

    it "returns a csv with the establishment type" do
      establishment = build(:academies_api_establishment)
      allow(establishment).to receive(:type).and_return("Test establishment type")
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("School type")
      expect(csv_export).to include("Test establishment type")
    end

    it "returns a csv with the establishment address" do
      establishment = build(:academies_api_establishment, address_street: "Test school address 1", address_locality: "Test school address 2", address_additional: "Test school address 3", address_town: "Test school town", address_county: "Test school county", address_postcode: "AB1 AB2")

      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("School address 1")
      expect(csv_export).to include("School address 2")
      expect(csv_export).to include("School address 3")
      expect(csv_export).to include("School town")
      expect(csv_export).to include("School county")
      expect(csv_export).to include("School postcode")

      expect(csv_export).to include("Test school address 1")
      expect(csv_export).to include("Test school address 2")
      expect(csv_export).to include("Test school address 3")
      expect(csv_export).to include("Test school town")
      expect(csv_export).to include("Test school county")
      expect(csv_export).to include("AB1 AB2")
    end

    it "returns a csv with the Local authority name" do
      local_authority = create(:local_authority, code: "300", name: "Test local authority name")
      establishment = build(:academies_api_establishment, local_authority_code: local_authority.code)
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Local authority")
      expect(csv_export).to include("Test local authority name")
    end

    it "returns a csv with the Local authority address" do
      local_authority = create(:local_authority, code: "300", address_1: "Test local authority address 1", address_2: "Test local authority address 2", address_3: "Test local authority address 3", address_town: "Test local authority address town", address_county: "Test local authority address county", address_postcode: "LS2 7EW")
      establishment = build(:academies_api_establishment, local_authority_code: local_authority.code)
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Local authority address 1")
      expect(csv_export).to include("Local authority address 2")
      expect(csv_export).to include("Local authority address 3")
      expect(csv_export).to include("Local authority address town")
      expect(csv_export).to include("Local authority address county")
      expect(csv_export).to include("Local authority address postcode")

      expect(csv_export).to include("Test local authority address 1")
      expect(csv_export).to include("Test local authority address 2")
      expect(csv_export).to include("Test local authority address 3")
      expect(csv_export).to include("Test local authority address town")
      expect(csv_export).to include("Test local authority address county")
      expect(csv_export).to include("LS2 7EW")
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

    it "returns a csv with the trust name" do
      trust = build(:academies_api_trust)
      allow(trust).to receive(:name).and_return("Test trust")
      project = build(:conversion_project, incoming_trust: trust)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Trust name")
      expect(csv_export).to include("Test trust")
    end

    it "returns a csv with the trust address" do
      trust = build(:academies_api_trust, address_street: "Test trust address 1", address_locality: "Test trust address 2", address_additional: "Test trust address 3", address_town: "Test trust address town", address_county: "Test trust address county", address_postcode: "AB1 AB2")
      project = build(:conversion_project, incoming_trust: trust)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Trust address 1")
      expect(csv_export).to include("Trust address 2")
      expect(csv_export).to include("Trust address 3")
      expect(csv_export).to include("Trust address town")
      expect(csv_export).to include("Trust address county")
      expect(csv_export).to include("Trust address county")
      expect(csv_export).to include("Trust address postcode")

      expect(csv_export).to include("Test trust address 1")
      expect(csv_export).to include("Test trust address 2")
      expect(csv_export).to include("Test trust address 3")
      expect(csv_export).to include("Test trust address town")
      expect(csv_export).to include("Test trust address county")
      expect(csv_export).to include("AB1 AB2")
    end
  end
end

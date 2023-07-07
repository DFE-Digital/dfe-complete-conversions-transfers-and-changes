require "rails_helper"

RSpec.describe OpeningProjectsCsvExporter do
  describe "#call" do
    before do
      mock_successful_api_response_to_create_any_project
      mock_successful_member_details
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

    it "returns a csv with the project type" do
      project = build(:conversion_project)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Project type")
      expect(csv_export).to include("Conversion")
    end

    context "a voluntary project" do
      it "returns a csv with the project route" do
        project = build(:conversion_project)

        csv_export = OpeningProjectsCsvExporter.new([project]).call

        expect(csv_export).to include("Route")
        expect(csv_export).to include("Voluntary")
      end
    end

    context "a sponsored project" do
      it "returns a csv with the project route" do
        project = build(:conversion_project, :sponsored)

        csv_export = OpeningProjectsCsvExporter.new([project]).call

        expect(csv_export).to include("Route")
        expect(csv_export).to include("Sponsored")
      end
    end

    it "returns a csv with the project conversion date" do
      project = build(:conversion_project, conversion_date: Date.new(2025, 5, 1))

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Conversion date")
      expect(csv_export).to include("2025-05-01")
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

    it "returns a csv with the Director of child services name" do
      local_authority = create(:local_authority)
      create(:director_of_child_services, name: "Test director of child services name", local_authority: local_authority)
      establishment = build(:academies_api_establishment, local_authority_code: local_authority.code)
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Test director of child services name")
      expect(csv_export).to include("Director of child services name")
    end

    it "returns a csv with the Director of child services role" do
      local_authority = create(:local_authority)
      create(:director_of_child_services, title: "Test director of child services role", local_authority: local_authority)
      establishment = build(:academies_api_establishment, local_authority_code: local_authority.code)
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Test director of child services role")
      expect(csv_export).to include("Director of child services role")
    end

    it "returns a csv with the Director of child services email" do
      local_authority = create(:local_authority)
      create(:director_of_child_services, email: "test@email.com", local_authority: local_authority)
      establishment = build(:academies_api_establishment, local_authority_code: local_authority.code)
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("test@email.com")
      expect(csv_export).to include("Director of child services email")
    end

    it "returns a csv with the Director of child services phone" do
      local_authority = create(:local_authority)
      create(:director_of_child_services, phone: "01234 567891", local_authority: local_authority)
      establishment = build(:academies_api_establishment, local_authority_code: local_authority.code)
      project = build(:conversion_project, establishment: establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("01234 567891")
      expect(csv_export).to include("Director of child services phone")
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

    context "when the Members API returns multiple results" do
      before do
        mock_nil_member_for_constituency_response
      end

      it "returns nil for the member contact details" do
        project = build(:conversion_project)

        csv_export = OpeningProjectsCsvExporter.new([project]).call

        expect(csv_export).to_not include("Member Parliment")
        expect(csv_export).to_not include("member.parliment@parliment.uk")
        expect(csv_export).to_not include("House of Commons")
        expect(csv_export).to_not include("London")
        expect(csv_export).to_not include("SW1A 0AA")
      end
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

    it "returns a csv with the approval date" do
      project = build(:conversion_project, advisory_board_date: Date.new(2022, 6, 1))

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Approval date")
      expect(csv_export).to include("2022-06-01")
    end

    it "returns a csv with the project lead" do
      user = build(:user, first_name: "Joe", last_name: "Bloggs")
      project = build(:conversion_project, assigned_to: user)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Project lead")
      expect(csv_export).to include("Joe Bloggs")
    end

    it "prepends a BOM to the file" do
      project = build(:conversion_project, urn: 654321)

      csv_export = OpeningProjectsCsvExporter.new([project]).call
      expect(csv_export.chr).to eq("\uFEFF")
    end

    it "sends the file in UTF-8 encoding" do
      project = build(:conversion_project, urn: 654321)

      csv_export = OpeningProjectsCsvExporter.new([project]).call
      expect(csv_export.encoding.name).to eq("UTF-8")
    end

    it "returns a csv with the new academy name" do
      establishment = build(:academies_api_establishment)
      allow(establishment).to receive(:name).and_return("New Academy")
      project = build(:conversion_project)
      allow(project).to receive(:academy).and_return(establishment)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Academy name")
      expect(csv_export).to include("New Academy")
    end

    it "returns an empty string when there is no academy" do
      project = build(:conversion_project)
      allow(project).to receive(:academy).and_return(nil)

      csv_export = OpeningProjectsCsvExporter.new([project]).call

      expect(csv_export).to include("Academy name")
    end
  end
end

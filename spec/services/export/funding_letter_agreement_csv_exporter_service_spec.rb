require "rails_helper"

RSpec.describe Export::FundingAgreementLettersCsvExporterService do
  describe "#call" do
    before do
      mock_successful_api_response_to_create_any_project
      mock_successful_member_details
    end

    it "returns a csv with headers and values" do
      user = build(:user, email: "user.name@education.gov.uk")
      project = build(:conversion_project, urn: 123456, assigned_to: user)

      csv_export = Export::FundingAgreementLettersCsvExporterService.new([project]).call

      expect(csv_export).to include("School URN")
      expect(csv_export).to include("123456")
      expect(csv_export).to include("Assigned to email")
      expect(csv_export).to include("user.name@education.gov.uk")
    end

    it "prepends a BOM to the file" do
      project = build(:conversion_project, urn: 654321)

      csv_export = Export::FundingAgreementLettersCsvExporterService.new([project]).call
      expect(csv_export.chr).to eq("\uFEFF")
    end

    it "sends the file in UTF-8 encoding" do
      project = build(:conversion_project, urn: 654321)

      csv_export = Export::FundingAgreementLettersCsvExporterService.new([project]).call
      expect(csv_export.encoding.name).to eq("UTF-8")
    end
  end
end

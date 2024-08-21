require "rails_helper"

RSpec.describe Export::Transfers::PreTransferGrantsCsvExportService do
  describe "#call" do
    before do
      mock_successful_api_response_to_create_any_project
    end

    it "returns a csv with headers and values" do
      user = build(:user, email: "user.name@education.gov.uk")
      rdo = build(:regional_delivery_officer_user, email: "rdo.name@education.gov.uk")
      project = build(:transfer_project, urn: 123456, assigned_to: user, regional_delivery_officer: rdo)

      csv_export = Export::Transfers::PreTransferGrantsCsvExportService.new([project]).call

      expect(csv_export).to include("Added by email")
      expect(csv_export).to include("rdo.name@education.gov.uk")
      expect(csv_export).to include("Assigned to email")
      expect(csv_export).to include("user.name@education.gov.uk")
    end
  end
end

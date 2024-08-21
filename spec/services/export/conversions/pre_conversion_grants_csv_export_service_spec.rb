require "rails_helper"

RSpec.describe Export::Conversions::PreConversionGrantsCsvExportService do
  describe "#call" do
    before do
      mock_successful_api_response_to_create_any_project
    end

    it "returns a csv with headers and values" do
      user = build(:user, email: "user.name@education.gov.uk")
      project = build(:conversion_project, urn: 123456, assigned_to: user)

      csv_export = Export::Conversions::PreConversionGrantsCsvExportService.new([project]).call

      expect(csv_export).to include("School URN")
      expect(csv_export).to include("123456")
      expect(csv_export).to include("Assigned to email")
      expect(csv_export).to include("user.name@education.gov.uk")
      expect(csv_export).to include("Region")
      expect(csv_export).to include("London")
      expect(csv_export).to include("School phase")
      expect(csv_export).to include("Secondary")
    end
  end
end

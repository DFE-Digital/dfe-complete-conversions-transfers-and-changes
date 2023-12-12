require "rails_helper"

RSpec.describe Export::Conversions::EducationAndSkillsFundingAgencyCsvExportService do
  describe "#call" do
    it "returns only the headers when there are no projects" do
      projects = []

      csv_export = described_class.new(projects).call

      expect(csv_export).to include("School URN")
      expect(csv_export).to include("Assigned to email")
    end

    it "returns a row of data" do
      mock_all_academies_api_responses
      project = build(:conversion_project)
      projects = [project]

      csv_export = described_class.new(projects).call

      expect(csv_export).to include(project.establishment.name)
      expect(csv_export).to include(project.assigned_to.email)
    end
  end
end

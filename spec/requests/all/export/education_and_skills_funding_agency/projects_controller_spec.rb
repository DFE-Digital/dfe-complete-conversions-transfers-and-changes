require "rails_helper"

RSpec.describe All::Export::EducationAndSkillsFundingAgency::ProjectsController, type: :request do
  let(:user) { create(:user, team: :education_and_skills_funding_agency) }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "#csv" do
    let!(:project) { create(:conversion_project, conversion_date: Date.new(2025, 5, 1), conversion_date_provisional: false) }

    it "returns the csv with a successful response" do
      get csv_all_export_education_and_skills_funding_agency_projects_path(5, 2025)
      expect(response.body).to include(project.urn.to_s)
      expect(response).to have_http_status(:success)
    end

    it "formats the csv filename with the month & year" do
      get csv_all_export_education_and_skills_funding_agency_projects_path(5, 2025)
      expect(response.header["Content-Disposition"]).to include("2025-5_risk_protection_arrangement_export.csv")
    end
  end
end

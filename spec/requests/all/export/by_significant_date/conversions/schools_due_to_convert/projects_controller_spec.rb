require "rails_helper"

RSpec.describe All::Export::BySignificantDate::Conversions::SchoolsDueToConvert::ProjectsController, type: :request do
  let(:user) { create(:user, team: :education_and_skills_funding_agency) }

  before do
    mock_all_academies_api_responses
    mock_successful_members_api_responses(member_name: build(:members_api_name), member_contact_details: [build(:members_api_contact_details)])
    sign_in_with(user)
  end

  describe "#index" do
    it "shows the next 6 months" do
      travel_to Date.new(2023, 1, 1) do
        get all_export_by_significant_date_conversions_schools_due_to_convert_projects_path
        expect(response.body).to include(
          "January 2023",
          "February 2023",
          "March 2023",
          "April 2023",
          "May 2023",
          "June 2023"
        )
      end
    end

    it "shows the counts of schools converting in the next 6 months" do
      _february_project = create(:conversion_project, significant_date: Date.new(2023, 2, 1))

      travel_to Date.new(2023, 1, 1) do
        get all_export_by_significant_date_conversions_schools_due_to_convert_projects_path
        expect(response.body).to include("1 <span class='govuk-visually-hidden'>school(s) converting in February 2023</span>")
      end
    end
  end

  describe "#show" do
    it "shows the info page for the CSV download" do
      get show_all_export_by_significant_date_conversions_schools_due_to_convert_projects_path(5, 2025)
      expect(response.body).to include("RPA, SUG and FA letters export for May 2025")
    end
  end

  describe "#csv" do
    let!(:project) { create(:conversion_project, significant_date: Date.new(2025, 5, 1), significant_date_provisional: false) }

    it "returns the csv with a successful response" do
      get csv_all_export_by_significant_date_conversions_schools_due_to_convert_projects_path(5, 2025)
      expect(response.body).to include(project.urn.to_s)
      expect(response).to have_http_status(:success)
    end

    it "formats the csv filename with the month & year" do
      get csv_all_export_by_significant_date_conversions_schools_due_to_convert_projects_path(5, 2025)
      expect(response.header["Content-Disposition"]).to include("2025-5_schools_due_to_convert.csv")
    end
  end
end

require "rails_helper"

RSpec.describe All::Export::ByMonth::Transfers::ProjectsController, type: :request do
  let(:user) { create(:user, team: :education_and_skills_funding_agency) }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "#index" do
    it "shows the next 6 months and links to Academies transferring in those months" do
      travel_to Date.new(2023, 1, 1) do
        get all_export_by_month_transfers_projects_path
        expect(response.body).to include(
          "January 2023",
          "February 2023",
          "March 2023",
          "April 2023",
          "May 2023",
          "June 2023"
        )
        expect(response.body).to include(
          "View January&#39;s confirmed transfers",
          "View January&#39;s revised transfers",
          "Download January&#39;s transfers"
        )
      end
    end
  end

  describe "#show" do
    it "shows the info page for the CSV download" do
      get show_all_export_by_month_transfers_projects_path(5, 2025)
      expect(response.body).to include("Details of academies due to transfer in May 2025")
    end
  end

  describe "#csv" do
    let!(:project) { create(:transfer_project, significant_date: Date.new(2025, 5, 1), significant_date_provisional: false) }

    it "returns the csv with a successful response" do
      get csv_all_export_by_month_transfers_projects_path(5, 2025)
      expect(response.body).to include(project.urn.to_s)
      expect(response).to have_http_status(:success)
    end

    it "formats the csv filename with the month & year" do
      get csv_all_export_by_month_transfers_projects_path(5, 2025)
      expect(response.header["Content-Disposition"]).to include("2025-5_academies_due_to_transfer.csv")
    end
  end
end

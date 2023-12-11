require "rails_helper"

RSpec.describe All::Export::FundingAgreementLetters::Conversions::ProjectsController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_all_academies_api_responses
    sign_in_with(team_leader)
  end

  describe "#csv" do
    let!(:project) { create(:conversion_project, conversion_date: Date.new(2025, 5, 1), conversion_date_provisional: false) }

    before { mock_successful_member_details }

    it "returns the csv with a successful response" do
      get csv_all_export_funding_agreement_letters_conversions_projects_path(5, 2025)
      expect(response.body).to include(project.urn.to_s)
      expect(response).to have_http_status(:success)
    end

    it "formats the csv filename with the month & year" do
      get csv_all_export_funding_agreement_letters_conversions_projects_path(5, 2025)
      expect(response.header["Content-Disposition"]).to include("2025-5_funding_agreement_letters_conversions_export.csv")
    end
  end
end

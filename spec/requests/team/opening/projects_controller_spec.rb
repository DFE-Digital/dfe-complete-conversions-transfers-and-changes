require "rails_helper"

RSpec.describe Team::Opening::ProjectsController, type: :request do
  let(:user) { create(:user, :caseworker, team: "regional_casework_services") }

  before do
    mock_all_academies_api_responses
    sign_in_with(user)
  end

  describe "#confirmed_next_month" do
    it "redirects to next month" do
      get confirmed_team_opening_projects_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(request.params.fetch(:month)).to eq Date.today.next_month.month.to_s
      expect(request.params.fetch(:year)).to eq Date.today.next_month.year.to_s
    end
  end

  describe "#revised_next_month" do
    it "redirects to next month" do
      get revised_team_opening_projects_path
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(request.params.fetch(:month)).to eq Date.today.next_month.month.to_s
      expect(request.params.fetch(:year)).to eq Date.today.next_month.year.to_s
    end
  end

  describe "#confirmed" do
    before do
      (100001..100002).each do |urn|
        mock_successful_api_responses(urn: urn, ukprn: 10061021)
      end

      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(mock_acadmies_api_fetcher)
    end

    let(:mock_acadmies_api_fetcher) { double(AcademiesApiPreFetcherService, call!: double) }

    it "only returns projects assigned to the user's team" do
      project_assigned_to_rcs = create(:conversion_project, urn: 100001, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, team: "regional_casework_services")
      project_assigned_to_rcs_2 = create(:conversion_project, urn: 100002, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, team: "regional_casework_services")
      project_assigned_to_region = create(:conversion_project, urn: 100003, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, team: "london")

      get "/projects/team/opening/confirmed/1/2022"

      expect(response.body).to include(project_assigned_to_rcs.urn.to_s)
      expect(response.body).to include(project_assigned_to_rcs_2.urn.to_s)
      expect(response.body).to_not include(project_assigned_to_region.urn.to_s)
    end
  end

  describe "#revised" do
    before do
      (100001..100002).each do |urn|
        mock_successful_api_responses(urn: urn, ukprn: 10061021)
      end

      allow(AcademiesApiPreFetcherService).to receive(:new).and_return(mock_acadmies_api_fetcher)
    end

    let(:mock_acadmies_api_fetcher) { double(AcademiesApiPreFetcherService, call!: double) }

    it "only returns projects assigned to the user's team" do
      project_assigned_to_rcs = create(:conversion_project, urn: 100001, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, team: "regional_casework_services")
      create(:date_history, project: project_assigned_to_rcs, previous_date: Date.new(2022, 1, 1), revised_date: Date.new(2022, 2, 1))
      create(:date_history, project: project_assigned_to_rcs, previous_date: Date.new(2022, 2, 1), revised_date: Date.new(2022, 3, 1))

      project_assigned_to_rcs_2 = create(:conversion_project, urn: 100002, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, team: "regional_casework_services")
      create(:date_history, project: project_assigned_to_rcs_2, previous_date: Date.new(2022, 1, 1), revised_date: Date.new(2022, 2, 1))
      create(:date_history, project: project_assigned_to_rcs_2, previous_date: Date.new(2022, 2, 1), revised_date: Date.new(2022, 3, 1))

      project_assigned_to_region = create(:conversion_project, urn: 100003, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false, region: "london")
      create(:date_history, project: project_assigned_to_region, previous_date: Date.new(2022, 1, 1), revised_date: Date.new(2022, 2, 1))
      create(:date_history, project: project_assigned_to_region, previous_date: Date.new(2022, 2, 1), revised_date: Date.new(2022, 3, 1))

      get "/projects/team/opening/revised/2/2022"

      expect(response.body).to include(project_assigned_to_rcs.urn.to_s)
      expect(response.body).to include(project_assigned_to_rcs_2.urn.to_s)
      expect(response.body).to_not include(project_assigned_to_region.urn.to_s)
    end
  end
end

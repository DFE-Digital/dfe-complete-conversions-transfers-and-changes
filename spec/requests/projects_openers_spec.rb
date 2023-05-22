require "rails_helper"

RSpec.describe ProjectsOpenersController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with(team_leader)
  end

  describe "#openers" do
    context "when the month and year are missing" do
      it "returns a 404" do
        get "/projects/openers"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the year is missing" do
      it "returns a 404" do
        get "/projects/openers/1"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the month isn't in the scope 1..12" do
      it "returns a 404" do
        get "/projects/openers/13/2022"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the year isn't in the scope 2000-2499" do
      it "returns a 404" do
        get "/projects/openers/12/2555"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the month and year are present and in scope" do
      before do
        (100001..100002).each do |urn|
          mock_successful_api_responses(urn: urn, ukprn: 10061021)
        end

        allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
        allow(IncomingTrustsFetcher).to receive(:new).and_return(mock_trusts_fetcher)
      end

      let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
      let(:mock_trusts_fetcher) { double(IncomingTrustsFetcher, call: true) }

      it "shows a page title with the month & year" do
        get "/projects/openers/1/2022"
        expect(response.body).to include("Academies opening in January 2022")
      end

      it "returns project details in table form" do
        conversion_project = create(:conversion_project, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false)
        get "/projects/openers/1/2022"
        expect(response.body).to include(
          conversion_project.establishment.name,
          conversion_project.urn.to_s,
          I18n.t("project.openers.route.#{conversion_project.route}")
        )
      end

      it "only returns projects whose confirmed conversion date is in that month & year" do
        project_in_scope = create(:conversion_project, urn: 100001, conversion_date: Date.new(2022, 1, 1), conversion_date_provisional: false)
        project_not_in_scope = create(:conversion_project, urn: 100002, conversion_date: Date.new(2022, 2, 1), conversion_date_provisional: false)

        get "/projects/openers/1/2022"
        expect(response.body).to include(project_in_scope.urn.to_s)
        expect(response.body).to_not include(project_not_in_scope.urn.to_s)
      end

      context "when there are no academies opening in that month & year" do
        it "shows a helpful message" do
          get "/projects/openers/1/2022"
          expect(response.body).to include("There are currently no schools expected to become academies in January 2022")
        end
      end
    end
  end
end

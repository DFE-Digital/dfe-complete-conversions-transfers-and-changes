require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with(team_leader)
  end

  describe "#index" do
    let!(:project) { create(:conversion_project) }
    let(:establishment) { build(:academies_api_establishment, urn: project.urn.to_s) }
    let(:trust) { build(:academies_api_trust, ukprn: project.incoming_trust_ukprn.to_s) }
    let(:establishments_response) { AcademiesApi::Client::Result.new([establishment], nil) }
    let(:trusts_response) { AcademiesApi::Client::Result.new([trust], nil) }
    let(:mock_client) do
      double(
        AcademiesApi::Client,
        get_establishments: establishments_response,
        get_trusts: trusts_response,
        get_establishment: true,
        get_trust: true
      )
    end

    subject(:perform_request) do
      get projects_path
      response
    end

    before do
      allow(AcademiesApi::Client).to receive(:new).and_return(mock_client)

      unset_api_data
    end

    it "bulk fetches establishments and trusts" do
      perform_request

      expect(mock_client).to have_received(:get_establishments).with(match_array([project.urn]))
      expect(mock_client).to have_received(:get_trusts).with(match_array([project.incoming_trust_ukprn]))

      expect(mock_client).to_not have_received(:get_establishment)
      expect(mock_client).to_not have_received(:get_trust)

      expect(response.body).to include(establishment.type, trust.name)
    end
  end

  describe "#show" do
    it "redirects to a 404 page when a project cannot be found" do
      project = create(:conversion_project)
      allow(Project).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      get project_path(project)

      expect(response).to have_http_status(:not_found)
    end
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
        conversion_project = create(:conversion_project, conversion_date: Date.new(2022, 1, 1))
        get "/projects/openers/1/2022"
        expect(response.body).to include(
          conversion_project.establishment.name,
          conversion_project.urn.to_s,
          conversion_project.incoming_trust.name,
          conversion_project.incoming_trust.ukprn
        )
      end

      it "only returns projects whose confirmed conversion date is in that month & year" do
        project_in_scope = create(:conversion_project, urn: 100001, conversion_date: Date.new(2022, 1, 1))
        project_not_in_scope = create(:conversion_project, urn: 100002, conversion_date: Date.new(2022, 2, 1))

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

  private def unset_api_data
    # Nillify any project data that comes from the API in order to best test the
    # real scenario, where loaded project data will not have associated API data until
    # it is requested.
    Project.all do |project|
      project.establishment = nil
      project.incoming_trust = nil
    end
  end
end

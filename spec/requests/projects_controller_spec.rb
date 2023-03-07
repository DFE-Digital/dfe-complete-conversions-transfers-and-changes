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

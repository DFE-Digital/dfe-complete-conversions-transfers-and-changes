require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with(team_leader)
  end

  describe "#show" do
    it "redirects to a 404 page when a project cannot be found" do
      project = create(:conversion_project)
      allow(Project).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      get project_path(project)

      expect(response).to have_http_status(:not_found)
    end
  end
end

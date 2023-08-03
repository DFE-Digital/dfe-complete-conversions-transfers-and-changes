require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with(user)
  end

  describe "#show" do
    let(:user) { create(:user, :team_leader) }

    it "redirects to a 404 page when a project cannot be found" do
      project = create(:conversion_project)
      allow(Project).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      get project_path(project)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "#index" do
    let(:user) { create(:user, :caseworker) }

    it "redirects to the in progress projects path" do
      get projects_path
      expect(response).to redirect_to(in_progress_your_projects_path)
    end
  end
end

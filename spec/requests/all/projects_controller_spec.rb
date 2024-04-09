require "rails_helper"

RSpec.describe ServiceSupport::ProjectsController, type: :request do
  before do
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  let!(:completed_project) { create(:conversion_project, :completed, completed_at: Date.today, urn: 165432) }
  let!(:project_without_urn) { create(:conversion_project, academy_urn: nil, urn: 132342) }
  let!(:project_with_urn) { create(:conversion_project, academy_urn: 123456, urn: 154232) }
  let(:establishment) { create(:gias_establishment, urn: 123456) }
  let(:user) { create(:user) }

  describe "without_academy_urn" do
    it "does not include completed projects" do
      get without_academy_urn_service_support_projects_path

      expect(response.body).to include project_without_urn.urn.to_s

      expect(response.body).not_to include completed_project.urn.to_s
      expect(response.body).not_to include project_with_urn.urn.to_s
    end
  end

  describe "with_academy_urn" do
    it "does not include completed projects" do
      get with_academy_urn_service_support_projects_path

      expect(response.body).to include project_with_urn.urn.to_s

      expect(response.body).not_to include completed_project.urn.to_s
      expect(response.body).not_to include project_without_urn.urn.to_s
    end
  end
end

require "rails_helper"

RSpec.describe "Completing projects", type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    allow_any_instance_of(ProjectsCompleteController).to receive(:user_id).and_return(user.id)
  end

  describe "the complete project button" do
    it "is not shown on a completed project" do
      project = create(:conversion_project, completed_at: DateTime.now)

      get conversion_project_path(project)

      expect(response).not_to render_template "conversion_projects/show/_complete"
    end
  end

  describe "completing an already completed project" do
    it "does not update the value of completed_at" do
      completed_date = DateTime.now
      project = create(:conversion_project, completed_at: completed_date)

      expect { put conversion_project_complete_path(project) }.not_to change { project.reload.completed_at }
    end
  end
end

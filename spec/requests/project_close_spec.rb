require "rails_helper"

RSpec.describe "Closing projects", type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    allow_any_instance_of(ProjectsCloseController).to receive(:user_id).and_return(user.id)
  end

  describe "the close project button" do
    it "is not shown on a closed project" do
      project = create(:project, closed_at: DateTime.now)

      get project_path(project)

      expect(response).not_to render_template "projects/show/_close"
    end
  end

  describe "closing a already closed project" do
    it "does not update the value of closed_at" do
      closed_date = DateTime.now
      project = create(:project, closed_at: closed_date)

      expect { put project_close_path(project) }.not_to change { project.reload.closed_at }
    end
  end
end

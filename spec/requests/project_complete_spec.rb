require "rails_helper"

RSpec.describe "Completing projects", type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: any_args, ukprn: 10061021)
  end

  describe "the complete project button" do
    it "is not shown on a completed project" do
      project = create(:conversion_project, state: :completed, completed_at: DateTime.now)

      get project_path(project)

      follow_redirect!

      expect(response.body).not_to include project_complete_path(project)
    end

    it "is not shown for a user that is not assigned to the project" do
      project = create(:conversion_project, completed_at: nil, assigned_to: build(:user))

      get project_path(project)

      follow_redirect!

      expect(response.body).not_to include project_complete_path(project)
    end

    it "is shown to a user that is assigned to an active project" do
      project = create(:conversion_project, state: :active, completed_at: nil, assigned_to: user)

      get project_path(project)

      follow_redirect!

      expect(response.body).to include project_complete_path(project)
    end
  end

  context "when a project is already completed" do
    it "shows a helpful banner" do
      project = create(:conversion_project, state: :completed, completed_at: Date.yesterday, assigned_to: user)

      get project_path(project)

      follow_redirect!

      expect(response.body).to include "Only Service Support team members can make changes to this project."
    end

    it "does not update the value of completed_at" do
      completed_date = DateTime.now
      project = create(:conversion_project, completed_at: completed_date)

      expect { put project_complete_path(project) }.not_to change { project.reload.completed_at }
    end
  end
end

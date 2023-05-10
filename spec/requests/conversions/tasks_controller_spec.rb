require "rails_helper"

RSpec.describe Conversions::TasksController do
  describe "#index" do
    it "render the task list" do
      user = create(:user)
      sign_in_with(user)
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)

      get project_conversion_tasks_path(project)

      expect(response).to have_http_status(:success)
      expect(response).to render_template("conversions/tasks/index")
    end
  end
end

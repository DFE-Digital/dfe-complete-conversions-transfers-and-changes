require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskListsController do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  describe "#index" do
    let(:project) { create(:conversion_project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get conversion_voluntary_tasks_path(project_id)
      response
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success

      expect(response.body).to include "Task list"
    end
  end
end

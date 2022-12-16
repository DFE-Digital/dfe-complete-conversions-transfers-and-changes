require "rails_helper"

RSpec.shared_examples "a task lists controller" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  describe "#index" do
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

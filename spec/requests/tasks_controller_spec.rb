require "rails_helper"

RSpec.describe TasksController, type: :request do
  describe "#show" do
    let(:task) { create(:task) }
    let(:project_id) { task.section.project.id }
    let(:task_id) { task.id }

    subject(:perform_request) do
      get project_task_path(project_id, task_id)
      response
    end

    before { mock_successful_api_responses(urn: 12345) }

    context "when the Task does not belong to the project" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Task is not found" do
      let(:task_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
      expect(subject.body).to include("Clear land questionnaire")
    end
  end
end
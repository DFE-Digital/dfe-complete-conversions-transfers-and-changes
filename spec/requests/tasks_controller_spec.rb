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

    context "when the Task is not found" do
      let(:task_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
      expect(subject.body).to include("Clear land questionnaire")
    end
  end

  describe "#update" do
    let(:completed_action) { create(:action, title: "Action 1", completed: true) }
    let(:incomplete_action) { create(:action, title: "Action 2") }
    let(:task) { create(:task, actions: [completed_action, incomplete_action]) }
    let(:project_id) { task.section.project.id }
    let(:task_id) { task.id }
    let(:params) { {task: {action_titles: [incomplete_action.title]}} }

    subject(:perform_request) do
      put project_task_path(project_id, task_id), params: params
      response
    end

    before { mock_successful_api_responses(urn: 12345) }

    context "when the Task is not found" do
      let(:task_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "updates the actions and redirects to the project show page" do
      perform_request

      expect(response).to redirect_to(project_path(project_id))
      expect(incomplete_action.reload.completed?).to be true
      expect(completed_action.reload.completed?).to be false
    end
  end
end

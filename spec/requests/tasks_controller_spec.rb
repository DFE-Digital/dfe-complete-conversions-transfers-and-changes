require "rails_helper"

RSpec.describe TasksController, type: :request do
  let(:user) { create(:user) }

  before do
    mock_successful_authentication(user.email)
    allow_any_instance_of(TasksController).to receive(:user_id).and_return(user.id)
  end

  describe "#show" do
    let(:section) { create(:section, title: "Project kick-off") }
    let(:task) { create(:task, section: section) }
    let(:project_id) { task.section.project.id }
    let(:task_id) { task.id }

    subject(:perform_request) do
      get conversion_project_task_path(project_id, task_id)
      response
    end

    before { mock_successful_api_responses(urn: 123456, ukprn: 10061021) }

    context "when the Task is not found" do
      let(:task_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response and renders the default template" do
      expect(subject).to have_http_status :success
      expect(subject.body).to include("Have you cleared the Supplementary funding agreement?")
      expect(subject).to render_template :show
    end

    it "can render actions with and without hint text" do
      _action_with_hint = create(:action, hint: "A hint.", task: task)
      _action_without_hint = create(:action, hint: nil, task: task)

      expect { perform_request }.not_to raise_error
    end
  end

  describe "#update" do
    let(:completed_action) { create(:action, title: "Action 1", completed: true) }
    let(:incomplete_action) { create(:action, title: "Action 2") }
    let(:task) { create(:task, actions: [completed_action, incomplete_action]) }
    let(:project_id) { task.section.project.id }
    let(:task_id) { task.id }
    let(:params) { {task: {actions: {completed_action.id => 0, incomplete_action.id => 1}}} } # These are inverted since we're testing the change of an action's status

    subject(:perform_request) do
      put conversion_project_task_path(project_id, task_id), params: params
      response
    end

    before { mock_successful_api_responses(urn: 123456, ukprn: 10061021) }

    context "when the Task is not found" do
      let(:task_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "updates the actions and redirects to the project show page" do
      perform_request

      expect(response).to redirect_to(conversion_project_path(project_id))
      expect(incomplete_action.reload.completed?).to be true
      expect(completed_action.reload.completed?).to be false
    end

    context "when the task is not applicable" do
      let(:task) { create(:task, :not_applicable, actions: [completed_action, completed_action]) }

      it "sets all the tasks actions completed state to false" do
        perform_request

        expect(task.reload.actions.first.completed?).to be false
        expect(task.reload.actions.last.completed?).to be false
      end
    end
  end
end

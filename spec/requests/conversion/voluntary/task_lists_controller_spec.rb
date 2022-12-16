require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskListsController do
  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }
  let(:index_path) { conversion_voluntary_tasks_path(project_id) }

  it_behaves_like "a task lists controller"

  describe "#edit" do
    let(:user) { create(:user, :caseworker) }
    let(:task) { build(:voluntary_conversion_task_handover) }
    let(:task_identifier) { task.class.identifier }

    before do
      sign_in_with(user)
      mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    end

    subject(:perform_request) do
      get conversion_voluntary_task_path(project_id, task_identifier)
      response
    end

    it "renders a task from the task template path" do
      expect(perform_request).to have_http_status :success
      expect(response).to render_template "conversion/voluntary/task_lists/tasks/handover"
    end
  end

  describe "#update" do
    let(:user) { create(:user, :caseworker) }
    let(:task) { build(:voluntary_conversion_task_handover) }
    let(:task_identifier) { task.class.identifier }
    let(:params) { {conversion_voluntary_tasks_handover: {review: 1, notes: 1, meeting: 0}} }

    subject(:perform_request) do
      put conversion_voluntary_task_path(project_id, task_identifier), params: params
      response
    end

    before do
      sign_in_with(user)
      mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    end

    it "saves the task against the task list and redirects to the task list index page" do
      perform_request

      expect(project.reload.task_list).to have_attributes(handover_review: true, handover_notes: true, handover_meeting: false)
      expect(response).to redirect_to(conversion_voluntary_tasks_path(project_id))
    end

    context "when the task is invalid" do
      before { allow_any_instance_of(Conversion::Voluntary::Tasks::Handover).to receive(:valid?).and_return(false) }

      it "renders the task template path" do
        perform_request

        expect(response).to render_template "conversion/voluntary/task_lists/tasks/handover"
      end
    end
  end
end

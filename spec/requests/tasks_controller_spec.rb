require "rails_helper"

RSpec.describe TasksController do
  let!(:user) { create(:user) }

  before do
    sign_in_with(user)
  end

  describe "#edit" do
    it "renders the correct edit view" do
      mock_successful_api_response_to_create_any_project
      project = create(:voluntary_conversion_project, assigned_to: user)

      get project_edit_task_path(project, :redact_and_send)

      expect(response).to render_template "conversions/tasks/redact_and_send/edit"
    end
  end

  describe "#update" do
    context "when the form is valid" do
      it "updates the task attributes and redirects to the tasks index" do
        mock_successful_api_response_to_create_any_project
        project = create(:voluntary_conversion_project, assigned_to: user)
        params = {
          conversion_task_redact_and_send_task_form: {
            redact: "1",
            send_redaction: "1",
            save_redaction: "1",
            send_solicitors: "1"
          }
        }

        put project_edit_task_path(project, :redact_and_send), params: params

        project.reload

        expect(project.tasks_data.redact_and_send_redact).to eql true
        expect(project.tasks_data.redact_and_send_send_redaction).to eql true
        expect(project.tasks_data.redact_and_send_save_redaction).to eql true
        expect(project.tasks_data.redact_and_send_send_solicitors).to eql true

        expect(response).to redirect_to(project_conversion_tasks_path(project))
      end
    end

    context "when the form is not valid" do
      it "renders the edit view and does not save the task" do
        mock_successful_api_response_to_create_any_project
        project = create(:voluntary_conversion_project, assigned_to: user)
        allow_any_instance_of(Conversion::Task::RedactAndSendTaskForm).to receive(:valid?).and_return(false)

        put project_edit_task_path(project, :redact_and_send)

        expect(response).to render_template "conversions/tasks/redact_and_send/edit"
        expect(project.tasks_data.redact_and_send_redact).to be_nil
      end
    end
  end
end

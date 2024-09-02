require "rails_helper"

RSpec.describe TasksController do
  let!(:user) { create(:user) }

  before do
    sign_in_with(user)
  end

  describe "#index" do
    it "render the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)

      get project_tasks_path(project)

      expect(response).to have_http_status(:success)
      expect(response).to render_template("tasks/index")
    end
  end

  describe "#edit" do
    it "renders the correct edit view" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project, assigned_to: user)

      get project_edit_task_path(project, :redact_and_send)

      expect(response).to render_template "conversions/tasks/redact_and_send/edit"
    end
  end

  describe "#update" do
    context "when the form is valid" do
      it "updates the task attributes and redirects to the tasks index" do
        mock_successful_api_response_to_create_any_project
        project = create(:conversion_project, assigned_to: user)
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

        expect(response).to redirect_to(project_tasks_path(project))
      end
    end

    context "when the form is not valid" do
      it "renders the edit view and does not save the task" do
        mock_successful_api_response_to_create_any_project
        project = create(:conversion_project, assigned_to: user)
        allow_any_instance_of(Conversion::Task::RedactAndSendTaskForm).to receive(:valid?).and_return(false)

        put project_edit_task_path(project, :redact_and_send)

        expect(response).to render_template "conversions/tasks/redact_and_send/edit"
        expect(project.tasks_data.redact_and_send_redact).to be_nil
      end
    end
  end

  context "when the task identifier is not valid" do
    it "renders a not found error" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project, assigned_to: user)

      get project_edit_task_path(project, :not_a_task)

      expect(response).to have_http_status :not_found
    end
  end

  describe "side navigation" do
    before do
      mock_all_academies_api_responses
    end

    describe "link to completing the project" do
      it "shows the link to complete a project" do
        conversion_project = create(:conversion_project, assigned_to: user)
        transfer_project = create(:transfer_project, assigned_to: user)

        get project_tasks_path(conversion_project)

        expect(response.body).to include "#completing-a-project"

        get project_tasks_path(transfer_project)

        expect(response.body).to include "#completing-a-project"
      end

      it "does not show a link when the user is not authorised" do
        conversion_project = create(:conversion_project, assigned_to: nil)
        transfer_project = create(:transfer_project, assigned_to: nil)

        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#completing-a-project"

        get project_tasks_path(transfer_project)

        expect(response.body).not_to include "#completing-a-project"
      end

      it "does not show a link when the project is complete" do
        conversion_project = create(:conversion_project, assigned_to: user, state: :completed, completed_at: Date.today)
        transfer_project = create(:transfer_project, assigned_to: user, state: :completed, completed_at: Date.today)

        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#completing-a-project"

        get project_tasks_path(transfer_project)

        expect(response.body).not_to include "#completing-a-project"
      end

      it "does not show when the project is DAO revoked" do
        conversion_project = create(:conversion_project, assigned_to: user, directive_academy_order: true, state: :dao_revoked)
        create(:dao_revocation, project: conversion_project)

        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#completing-a-project"
      end
    end

    describe "link to DAO revocation" do
      it "shows on conversions that have a DAO" do
        conversion_project = create(
          :conversion_project,
          assigned_to: user,
          directive_academy_order: true
        )

        get project_tasks_path(conversion_project)

        expect(response.body).to include "#dao-revocation"
      end

      it "does not show if the user is not authorised" do
        conversion_project = create(
          :conversion_project,
          assigned_to: nil,
          directive_academy_order: true
        )

        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#dao-revocation"
      end

      it "does not show on transfers" do
        transfer_project = create(
          :transfer_project,
          assigned_to: user
        )

        get project_tasks_path(transfer_project)

        expect(response.body).not_to include "#dao-revocation"
      end

      it "does not show on conversion without a DAO" do
        conversion_project = create(
          :conversion_project,
          assigned_to: user,
          directive_academy_order: false
        )

        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#dao-revocation"
      end

      it "does not show on projects that have already had the DAO revoked" do
        conversion_project = create(
          :conversion_project,
          assigned_to: user,
          directive_academy_order: true,
          state: :dao_revoked
        )
        create(:dao_revocation, project: conversion_project)

        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#dao-revocation"
      end

      it "does not show when the project is complete" do
        conversion_project = create(
          :conversion_project,
          assigned_to: user,
          state: :completed,
          completed_at: Date.today,
          directive_academy_order: true
        )
        get project_tasks_path(conversion_project)

        expect(response.body).not_to include "#dao-revocation"
      end
    end
  end
end

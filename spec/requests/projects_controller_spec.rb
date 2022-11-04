require "rails_helper"

RSpec.describe ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

  before do
    mock_successful_authentication(regional_delivery_officer.email)
    allow_any_instance_of(ProjectsController).to receive(:user_id).and_return(regional_delivery_officer.id)
  end

  describe "#create" do
    let(:project) { build(:project) }
    let(:project_params) { attributes_for(:project, regional_delivery_officer: nil) }
    let(:note_params) { {body: "new note"} }
    let!(:team_leader) { create(:user, :team_leader) }

    subject(:perform_request) do
      post projects_path, params: {project: {**project_params, note: note_params}}
      response
    end

    context "when the project is not valid" do
      before do
        allow(Project).to receive(:new).and_return(project)
        allow(project).to receive(:valid?).and_return false
      end

      it "re-renders the new template" do
        expect(perform_request).to render_template :new
      end
    end

    context "when the project is valid" do
      let(:task_list_creator) { TaskListCreator.new }
      let(:new_project_record) { Project.last }

      before do
        mock_successful_api_responses(urn: 123456, ukprn: 10061021)

        allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
        allow(task_list_creator).to receive(:call).and_return true

        perform_request
      end

      it "assigns the regional delivery officer, calls the TaskListCreator, and redirects to the project path" do
        expect(response).to redirect_to(project_path(new_project_record.id))
        expect(task_list_creator).to have_received(:call).with(new_project_record, workflow_root: ProjectsController::DEFAULT_WORKFLOW_ROOT)
        expect(new_project_record.regional_delivery_officer).to eq regional_delivery_officer
      end

      it "creates a new project and note" do
        expect(Project.count).to be 1
        expect(Note.count).to be 1
        expect(Note.last.user).to eq regional_delivery_officer
      end

      it "sends a new project created email to team leaders" do
        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
          .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, new_project_record]))
      end

      context "when the note body is empty" do
        let(:note_params) { {body: ""} }

        it "does not create a new note" do
          expect(Note.count).to be 0
        end
      end
    end

    context "when the task list cannot be created" do
      let(:task_list_creator) { TaskListCreator.new }

      before do
        mock_successful_api_responses(urn: 123456, ukprn: 10061021)

        allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
        allow(task_list_creator).to receive(:call).and_raise(RuntimeError)
      end

      it "does not create a project" do
        expect { perform_request }.to raise_error(RuntimeError)
        expect(Project.count).to be 0
      end
    end
  end
end

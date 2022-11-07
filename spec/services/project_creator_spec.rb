require "rails_helper"

RSpec.describe ProjectCreator do
  let(:project_creator) { ProjectCreator.new }
  let(:user) { create(:user) }
  let(:project_attributes) { attributes_for(:project).except(:team_leader, :regional_delivery_officer) }
  let(:project_form) { ProjectForm.new(**project_attributes, regional_delivery_officer_id: user.id) }
  let(:note_body) { "Some body" }
  let(:note_form) { NoteForm.new(body: note_body, user_id: user.id) }
  let!(:team_leader) { create(:user, :team_leader) }

  describe "#call" do
    let(:project) { create(:project) }
    let(:mock_task_list_creator) { TaskListCreator.new }
    let(:new_project_record) { Project.last }

    subject { project_creator.call(project_form, note_form) }

    before do
      mock_successful_api_responses(urn: 123456, ukprn: 10061021)
      ActiveJob::Base.queue_adapter = :test

      allow(TaskListCreator).to receive(:new).and_return(mock_task_list_creator)
      allow(mock_task_list_creator).to receive(:call).and_return true
    end

    it "calls the TaskListCreator" do
      subject

      expect(mock_task_list_creator).to have_received(:call).with(new_project_record, workflow_root: ProjectCreator::DEFAULT_WORKFLOW_ROOT)
    end

    it "creates a new project and note" do
      subject

      expect(Project.count).to be 1
      expect(Note.count).to be 1
      expect(Note.last.user).to eq user
    end

    it "sends a new project created email to team leaders" do
      subject

      expect(ActionMailer::MailDeliveryJob)
        .to(have_been_enqueued.on_queue("default")
                              .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, new_project_record]))
    end

    it "returns the new project" do
      expect(subject).to eq Project.last
    end

    context "when the note body is empty" do
      let(:note_body) { nil }

      it "does not create a new note" do
        expect(Note.count).to be 0
      end
    end

    context "when the project is invalid" do
      let(:mock_project_form) { ProjectForm.new }

      before do
        allow(ProjectForm).to receive(:new).and_return(mock_project_form)
        allow(mock_project_form).to receive(:invalid?).and_return true
      end

      it { expect(subject).to be false }
    end

    context "when the note is invalid" do
      let(:mock_note_form) { NoteForm.new(body: "Some body") }

      before do
        allow(NoteForm).to receive(:new).and_return(mock_note_form)
        allow(mock_note_form).to receive(:invalid?).and_return true
      end

      it { expect(subject).to be false }
    end

    context "when the task list cannot be created" do
      let(:mock_task_list_creator) { TaskListCreator.new }

      before do
        allow(TaskListCreator).to receive(:new).and_return(mock_task_list_creator)
        allow(mock_task_list_creator).to receive(:call).and_raise(RuntimeError)
      end

      it "does not create any records" do
        expect { subject }.to raise_error(RuntimeError)

        expect(Project.count).to be 0
        expect(Note.count).to be 0
        expect(Task.count).to be 0
      end
    end
  end
end

require "rails_helper"

RSpec.describe Conversion::Task::UpdateEsfaTaskForm do
  let(:user) { create(:user) }

  describe "#status" do
    context "when the task is not checked and there is no task note" do
      it "returns not started" do
        project = build(:conversion_project)
        task_form = described_class.new(project.tasks_data, user)
        allow(project.tasks_data).to receive(:project).and_return(project)

        expect(task_form.status).to eql(:not_started)
      end
    end

    context "when the task is not checked and there is a task note" do
      it "returns in progress" do
        project = build(:conversion_project)
        note = build(:note, task_identifier: :update_esfa, project: project)
        task_form = described_class.new(project.tasks_data, user)

        allow(project).to receive(:notes).and_return([note])
        allow(project.tasks_data).to receive(:project).and_return(project)

        expect(task_form.status).to eql(:in_progress)
      end
    end

    context "when the task is checked but the note is not for the task" do
      it "returns in progress" do
        project = build(:conversion_project)
        note = build(:note, task_identifier: :not_this_task, project: project)
        task_form = described_class.new(project.tasks_data, user)
        task_form.assign_attributes(update: true)

        allow(project).to receive(:notes).and_return([note])
        allow(project.tasks_data).to receive(:project).and_return(project)

        expect(task_form.status).to eql(:in_progress)
      end
    end

    context "when the task is checked but there is no task note" do
      it "returns in progress" do
        project = build(:conversion_project)
        task_form = described_class.new(project.tasks_data, user)
        task_form.assign_attributes(update: true)

        allow(project.tasks_data).to receive(:project).and_return(project)

        expect(task_form.status).to eql(:in_progress)
      end
    end

    context "when the task is checked and there is a tasks note" do
      it "returns completed" do
        project = build(:conversion_project)
        note = build(:note, task_identifier: :update_esfa, project: project)
        task_form = described_class.new(project.tasks_data, user)
        task_form.assign_attributes(update: true)

        allow(project).to receive(:notes).and_return([note])
        allow(project.tasks_data).to receive(:project).and_return(project)

        expect(task_form.status).to eql(:completed)
      end
    end
  end
end

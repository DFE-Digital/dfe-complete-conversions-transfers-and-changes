require "rails_helper"

RSpec.shared_examples "a task list" do
  describe "#sections" do
    it "returns all sections with tasks" do
      first_section = task_list.sections.first

      expect(first_section).to be_an_instance_of(TaskList::Section)
      expect(first_section.identifier).to be :project_kick_off
      expect(first_section.tasks.first).to be_an_instance_of(task_class)
    end
  end

  describe "#tasks" do
    it "returns a flattened array of the tasks for all sections" do
      expect(task_list.tasks.first).to be_an_instance_of(task_class)
    end
  end

  describe "#task" do
    it "returns a single task by its identifier" do
      task_identifier = "handover"

      task = task_list.task(task_identifier)

      expect(task).to be_an_instance_of(task_class)
    end
  end

  describe "#save_task" do
    it "saves the attributes for the task" do
      task_identifier = "handover"

      task = task_list.task(task_identifier)

      task.assign_attributes(review: false)
      task_list.save_task(task)

      expect(task_list.reload.handover_review).to be false
    end
  end

  describe "#task_list_layout" do
    context "when undefined" do
      let(:task_list_dup) { task_list.class.dup }
      let(:error_message) { "Task lists must define a `#task_list_layout`." }

      before { task_list_dup.remove_method(:task_list_layout) }

      it "raises a #{NoMethodError}" do
        expect { task_list_dup.new.task_list_layout }.to raise_error(NoMethodError, error_message)
      end
    end
  end
end

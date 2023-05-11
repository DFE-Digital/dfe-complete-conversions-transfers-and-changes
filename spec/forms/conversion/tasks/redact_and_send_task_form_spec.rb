require "rails_helper"

RSpec.describe Conversion::Task::RedactAndSendTaskForm do
  let(:user) { create(:user) }

  describe ".identifier" do
    it "returns the class name without 'TaskForm' as a string" do
      expect(described_class.identifier).to eql "redact_and_send"
    end
  end

  describe "#identifier" do
    it "returns the class name without 'TaskForm' as a symbol" do
      task_form = described_class.new(Conversion::TasksData.new, user)

      expect(task_form.identifier).to eql :redact_and_send
    end
  end

  describe "#save" do
    context "when the form is valid" do
      it "updates the task list data" do
        task_data = Conversion::TasksData.new
        task_form = described_class.new(task_data, user)
        task_form.save_redaction = true

        task_form.save

        expect(task_data.redact_and_send_save_redaction).to eql true
      end
    end

    context "when the form is invalid" do
      it "raises error" do
        task_data = Conversion::TasksData.new
        task_form = described_class.new(task_data, user)
        allow(task_data).to receive(:valid?).and_return(false)

        expect { task_form.save }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "#status" do
    context "when the task has no completed actions" do
      it "returns :not_started" do
        task_data = Conversion::TasksData.new
        task_form = described_class.new(task_data, user)

        expect(task_form.status).to eql :not_started
      end
    end

    context "when the task has some completed actions" do
      it "returns :in_progress" do
        task_data = Conversion::TasksData.new
        task_form = described_class.new(task_data, user)

        task_form.redact = true

        expect(task_form.status).to eql :in_progress
      end
    end

    context "when the task has all completed actions" do
      it "returns :completed" do
        task_data = Conversion::TasksData.new
        task_form = described_class.new(task_data, user)

        task_form.redact = true
        task_form.save_redaction = true
        task_form.send_redaction = true
        task_form.send_solicitors = true

        expect(task_form.status).to eql :completed
      end
    end
  end

  describe "#locales_path" do
    it "returns the task path without 'TaskForm' as a dot list" do
      task_form = described_class.new(Conversion::TasksData.new, user)

      expect(task_form.locales_path).to eql "conversion.task.redact_and_send"
    end
  end
end

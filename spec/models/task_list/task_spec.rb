require "rails_helper"

RSpec.describe TaskList::Task, type: :model do
  let(:testing_model) { Conversion::Voluntary::TestingClass }
  let(:testing_model_instance) { testing_model.new }

  describe ".identifier" do
    subject { testing_model.identifier }

    it "returns a snake_case identifier based on the class name" do
      expect(subject).to eq("testing_class")
    end
  end

  describe "#title" do
    let(:title) { "Test title" }

    before { allow(I18n).to receive(:t).with("task_list.tasks.#{testing_model.identifier}.title").and_return(title) }

    subject { testing_model_instance.title }

    it "returns the task title from the translation file" do
      expect(subject).to eq title
    end
  end

  describe "#status" do
    subject { testing_model_instance.status }

    before { testing_model_instance.assign_attributes(received:, description:) }

    context "when not applicable" do
      let(:received) { true }
      let(:description) { "A description" }

      before do
        testing_model_instance.class_eval do
          private def not_applicable?
            true
          end
        end
      end

      it { expect(subject).to be :not_applicable }
    end

    context "when all values are present" do
      let(:received) { true }
      let(:description) { "A description" }

      it { expect(subject).to be :completed }
    end

    context "when some values are present" do
      let(:received) { true }
      let(:description) { "" }

      it { expect(subject).to be :in_progress }
    end

    context "when no values are present" do
      let(:received) { false }
      let(:description) { "" }

      it { expect(subject).to be :not_started }
    end
  end
end

class Conversion::Voluntary::TestingClass < TaskList::Task
  attribute :received, :boolean
  attribute :description, :string
end

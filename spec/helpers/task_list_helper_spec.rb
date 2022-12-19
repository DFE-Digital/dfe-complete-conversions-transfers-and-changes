require "rails_helper"

RSpec.describe TaskListHelper, type: :helper do
  describe "#task_status_id" do
    let(:task_title) { "Clear land questionnaire" }

    it "returns the task title as kebab case with '-status' appended" do
      expect(helper.task_status_id(task_title)).to eq "clear-land-questionnaire-status"
    end
  end

  describe "#section_title" do
    let(:locales) { :conversion_involuntary_task_list }
    let(:section_identifier) { "project_kick_off" }
    let(:title) { "Project kick-off" }

    before { allow(I18n).to receive(:t).with("#{locales}.sections.#{section_identifier}").and_return(title) }

    subject { helper.section_title(locales, section_identifier) }

    it "returns the section title from the translation file" do
      expect(subject).to eq title
    end
  end

  describe "#task_title" do
    let(:locales) { :conversion_involuntary_task_list }
    let(:title) { "Handover with the Regional Delivery Officer" }
    let(:task_identifier) { "handover" }

    before { allow(I18n).to receive(:t).with("#{locales}.tasks.#{task_identifier}").and_return(title) }

    subject { helper.task_title(locales, task_identifier) }

    it "returns the section title from the translation file" do
      expect(subject).to eq title
    end
  end

  describe "#task_status_tag" do
    let(:task) { Task.new }
    let(:task_status_id) { "clear-land-questionnaire-status" }

    it "returns a tag representing the task status when the status is known" do
      allow(task).to receive(:status).and_return(:completed)
      expect(helper.task_status_tag(task, task_status_id)).to eq "<strong class=\"govuk-tag govuk-tag--turquoise app-task-list__tag\" id=\"#{task_status_id}\">Completed</strong>"
    end

    it "returns a tag representing an unknown status where the status is not known" do
      allow(task).to receive(:status).and_return(:unexpected)
      expect(helper.task_status_tag(task, task_status_id)).to eq "<strong class=\"govuk-tag govuk-tag--grey app-task-list__tag\" id=\"#{task_status_id}\">Unknown</strong>"
    end
  end
end

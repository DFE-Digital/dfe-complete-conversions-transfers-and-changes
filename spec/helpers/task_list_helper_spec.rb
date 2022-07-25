require "rails_helper"

RSpec.describe TaskListHelper, type: :helper do
  describe "#task_status_id" do
    let(:task) { Task.new(title: "Clear land questionnaire") }

    it "returns the task title as kebab case with '-status' appended" do
      expect(helper.task_status_id(task)).to eq "clear-land-questionnaire-status"
    end
  end

  describe "#task_status_tag" do
    let(:task) { Task.new(title: "Clear land questionnaire") }

    it "returns a tag representing the task status" do
      expect(helper.task_status_tag(task)).to eq '<strong class="govuk-tag govuk-tag--grey app-task-list__tag" id="clear-land-questionnaire-status">Unknown</strong>'
    end
  end
end

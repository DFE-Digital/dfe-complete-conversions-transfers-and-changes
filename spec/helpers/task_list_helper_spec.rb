require "rails_helper"

RSpec.describe TaskListHelper, type: :helper do
  describe "#task_status_id" do
    let(:task) { create(:task) }

    it "returns the task title as kebab case with '-status' appended" do
      expect(helper.task_status_id(task)).to eq "clear-land-questionnaire-status"
    end
  end
end

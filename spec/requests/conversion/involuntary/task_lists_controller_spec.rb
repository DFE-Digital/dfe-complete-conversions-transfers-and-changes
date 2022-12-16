require "rails_helper"

RSpec.describe Conversion::Involuntary::TaskListsController do
  let(:project) { create(:involuntary_conversion_project) }
  let(:project_id) { project.id }
  let(:index_path) { conversion_involuntary_tasks_path(project_id) }
  let(:task) { build(:involuntary_conversion_task_handover) }
  let(:edit_path) { conversion_involuntary_task_path(project_id, task_identifier) }
  let(:edit_template_path) { "conversion/involuntary/task_lists/tasks/handover" }
  let(:update_path) { conversion_involuntary_task_path(project_id, task_identifier) }
  let(:update_params) { {conversion_involuntary_tasks_handover: {review: 1}} }
  let(:expected_update_attributes) { {handover_review: true} }

  it_behaves_like "a task lists controller"
end

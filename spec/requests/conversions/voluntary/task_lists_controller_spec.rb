require "rails_helper"

RSpec.describe Conversions::Voluntary::TaskListsController do
  let(:project) { create(:voluntary_conversion_project, assigned_to: user) }
  let(:project_id) { project.id }
  let(:index_path) { conversions_voluntary_project_task_list_path(project_id) }
  let(:task) { build(:voluntary_conversion_task_handover) }
  let(:edit_path) { conversions_voluntary_project_edit_task_path(project_id, task_identifier) }
  let(:edit_template_path) { "conversions/voluntary/task_lists/tasks/handover" }
  let(:update_path) { conversions_voluntary_project_update_task_path(project_id, task_identifier) }
  let(:update_params) { {conversion_voluntary_tasks_handover: {review: 1, notes: 1, meeting: 0}} }
  let(:expected_update_attributes) { {handover_review: true, handover_notes: true, handover_meeting: false} }

  it_behaves_like "a task lists controller"
end

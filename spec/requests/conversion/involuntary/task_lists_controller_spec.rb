require "rails_helper"

RSpec.describe Conversion::Involuntary::TaskListsController do
  let(:project) { create(:involuntary_conversion_project) }
  let(:project_id) { project.id }
  let(:index_path) { conversion_involuntary_tasks_path(project_id) }

  it_behaves_like "a task lists controller"
end

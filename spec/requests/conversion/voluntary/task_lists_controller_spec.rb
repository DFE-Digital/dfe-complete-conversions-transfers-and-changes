require "rails_helper"

RSpec.describe Conversion::Voluntary::TaskListsController do
  let(:project) { create(:conversion_project) }
  let(:project_id) { project.id }
  let(:index_path) { conversion_voluntary_tasks_path(project_id) }

  it_behaves_like "a task lists controller"
end

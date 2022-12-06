class Conversion::Voluntary::TaskList::BaseTasksController < ::ApplicationController
  before_action :find_project, :find_task_list

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_task_list
    # Should be able to do @project.task_list. I must have set the association up wrong
    @task_list = Conversion::Voluntary::TaskList.find_by(project: @project)
  end
end

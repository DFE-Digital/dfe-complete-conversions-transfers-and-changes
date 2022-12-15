class TaskListController < ApplicationController
  before_action :find_project, :find_task_list

  def index
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_task_list
    @task_list = @project.task_list
  end
end

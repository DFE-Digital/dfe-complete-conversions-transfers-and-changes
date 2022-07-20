class TasksController < ApplicationController
  before_action :find_task

  def show
  end

  def update
    titles = action_params[:action_titles]

    @task.actions.update_all(completed: false)
    @task.actions.where(title: titles).update_all(completed: true)
  end

  def action_params
    params.require(:task).permit(action_titles: [])
  end

  private def find_task
    @task = Task.joins(:section).where(section: {project: params[:project_id]}).find(params[:id])
  end
end

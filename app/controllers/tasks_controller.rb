class TasksController < ApplicationController
  before_action :find_task

  def show
  end

  def update
    titles = action_params[:action_titles]

    @task.actions.update_all(completed: false)
    @task.actions.where(title: titles).update_all(completed: true)

    redirect_to(project_path(@task.project))
  end

  def action_params
    params.require(:task).permit(action_titles: [])
  end

  private def find_task
    @task = Task.find(params[:id])
  end
end

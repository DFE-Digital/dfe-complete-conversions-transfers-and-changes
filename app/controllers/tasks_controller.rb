class TasksController < ApplicationController
  include Authentication
  before_action :find_task

  def show
  end

  def update
    @task.actions.each do |action|
      action_completed = action.id.in?(action_params[:completed_action_ids] || [])
      Action.update(action.id, completed: action_completed)
    end

    redirect_to(project_path(@task.project))
  end

  def action_params
    params.require(:task).permit(completed_action_ids: [])
  end

  private def find_task
    @task = Task.find(params[:id])
  end
end

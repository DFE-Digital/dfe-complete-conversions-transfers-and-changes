class TasksController < ApplicationController
  before_action :find_task
  before_action :find_task_level_notes, only: :show

  def show
    render "tasks/clear_legal_documents/show" if @task.clear_legal_documents_type?
  end

  def update
    @task.actions.each do |action|
      action_completed = action.id.in?(task_params[:completed_action_ids] || [])
      Action.update(action.id, completed: action_completed)
    end

    @task.update(not_applicable: not_applicable)
    unset_all_actions if @task.not_applicable?

    redirect_to(project_path(@task.project))
  end

  def task_params
    params.require(:task).permit(:not_applicable, completed_action_ids: [])
  end

  private def find_task
    @task = Task.find(params[:id])
  end

  private def find_task_level_notes
    @notes = Note.includes([:user]).where(task: @task)
  end

  private def not_applicable
    params.dig("task", "not_applicable")
  end

  private def unset_all_actions
    @task.actions.update_all(completed: false)
  end
end

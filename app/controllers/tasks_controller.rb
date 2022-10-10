class TasksController < ApplicationController
  before_action :find_task
  before_action :find_task_level_notes, only: :show

  def show
  end

  def update
    # If the task is not applicable, just unset all the actions instead of updating them all.
    if not_applicable
      unset_all_actions
    else
      @task.actions.includes([:task]).each do |action|
        action.update(completed: params.dig("task", "actions", action.id) || false)
      end
    end

    # The task's not applicable state should be updated regardless of the above logic
    @task.update(not_applicable: not_applicable)

    redirect_to(project_path(@task.project))
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

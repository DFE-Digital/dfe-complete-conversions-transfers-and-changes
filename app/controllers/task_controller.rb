class TaskController < ApplicationController

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  def show
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])

    puts params

    @task.update(
      completed: params[:task][:completed]
    )

    redirect_to project_path(id: @project.id)
  end

end

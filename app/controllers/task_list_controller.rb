class TaskListController < ApplicationController
  before_action :find_project, :find_task_list
  before_action :find_task, only: %i[edit update]

  def index
  end

  def edit
    render task_template_path(@task.class.identifier)
  end

  def update
    @task.assign_attributes task_params

    if @task.valid?
      @task_list.save_task(@task)

      redirect_to action: :index
    else
      render task_template_path(@task.class.identifier)
    end
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_task_list
    @task_list = @project.task_list
  end

  private def find_task
    @task = @task_list.task(params[:task_id])
  end

  private def task_params
    params.fetch(task_param_key, {}).permit @task.attributes.keys
  end

  def task_param_key
    @task.class.model_name.param_key
  end
end

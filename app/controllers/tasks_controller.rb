class TasksController < ApplicationController
  before_action :find_project, :find_tasks_data, :find_task, :find_task_notes

  def edit
    render task_view
  end

  def update
    authorize @tasks_data
    @task.assign_attributes task_params

    if @task.valid?
      @task.save
      redirect_to conversions_tasks_path(@project), notice: t("task_list.save.success")
    else
      render task_view
    end
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_tasks_data
    @tasks_data = @project.task_list
  end

  private def find_task
    @task = klass_from_path.new(@tasks_data, current_user)
  end

  private def task_params
    params.fetch(task_param_key, {}).permit @task.attributes.keys
  end

  private def task_param_key
    @task.class.model_name.param_key
  end

  private def find_task_notes
    @notes = Note.includes([:user, :project]).where(project: @project, task_identifier: @task.identifier)
  end

  private def klass_from_path
    "#{project_type}::Task::#{task_klass_identifier}TaskForm".constantize
  end

  private def task_view
    "#{project_type.pluralize}/tasks/#{task_identifier}/edit".downcase
  end

  private def project_type
    @project.class.name.split("::").first
  end

  private def task_identifier
    params.fetch(:task_identifier).underscore
  end

  private def task_klass_identifier
    task_identifier.underscore.camelize
  end
end

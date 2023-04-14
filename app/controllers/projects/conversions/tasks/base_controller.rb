class Projects::Conversions::Tasks::BaseController < ApplicationController
  before_action :find_project, :find_task_list
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index

  end

  def edit
    render task_template_path(@task.class.identifier)
  end

  def update
    authorize @task_list
    @task.assign_attributes task_params

    if @task.valid?
      @task_list.user = current_user
      @task_list.save_task(@task)

      redirect_to action: :index
    else
      render task_template_path(@task.class.identifier)
    end
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

  private def task_param_key
    @task.class.model_name.param_key
  end

  private def find_task_notes
    @notes = Note.includes([:user, :project]).where(project: @project, task_identifier: @task.class.identifier)
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def attributes_for_task(task)
    attributes
      .select { |key| key.start_with?(task.identifier) }
      .transform_keys { |key| key.sub("#{task.identifier}_", "") }
  end

  private def find_task_notes
    @notes = Note.includes([:user, :project]).where(project: @project, task_identifier: @task.class.identifier)
  end
end

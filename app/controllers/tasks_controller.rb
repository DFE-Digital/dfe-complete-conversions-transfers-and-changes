class TasksController < ApplicationController
  include Projectable

  before_action :find_tasks_data
  before_action :find_task, :find_task_notes, except: :index

  class TaskKlassNotFoundError < StandardError; end

  rescue_from TaskKlassNotFoundError, with: :not_found_error

  def index
    case @project.type
    when "Conversion::Project"
      @task_list = Conversion::TaskList.new(@project, current_user)
    when "Transfer::Project"
      @task_list = Transfer::TaskList.new(@project, current_user)
    end
  end

  def edit
    render task_view
  end

  def update
    authorize @tasks_data
    @task.assign_attributes task_params

    if @task.valid?
      @task.save
      redirect_to project_tasks_path(@project), notice: I18n.t("task_list.save.success")
    else
      render task_view
    end
  end

  private def find_tasks_data
    @tasks_data = @project.tasks_data
  end

  private def find_task
    task_klass = klass_from_path
    raise TaskKlassNotFoundError.new(task_identifier) unless task_klass

    @task = task_klass.new(@tasks_data, current_user)
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
  rescue NameError
    nil
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

class Conversion::Voluntary::TaskListController < ::ApplicationController
  before_action :find_project, :find_task_list
  before_action :find_task, only: [:edit, :update]

  def index
  end

  def edit
  end

  def update
    @task.assign_attributes task_params

    if @task.valid?
      args = { params[:id].to_s => @task }
      @task_list.update!(args)

      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  def task_path(task = params[:id])
    edit_project_conversion_voluntary_task_list_path(@project, task)
  end
  helper_method :task_path

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def find_task_list
    # Should be able to do @project.task_list. I must have set the association up wrong
    @task_list = Conversion::Voluntary::TaskList.find_by(project: @project)
  end

  private def find_task
    @task = @task_list.send(params[:id])
  end

  private def task_params
    params.fetch(task_param_key, {}).permit @task.attributes.keys
  end

  def task_param_key
    @task.class.model_name.param_key
  end
end

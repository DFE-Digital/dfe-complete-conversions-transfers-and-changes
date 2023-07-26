class ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def show
    @project = Project.find(params[:id])
    authorize @project

    # TODO: Temporary until we add Tasks for Transfer Projects
    case @project.type
    when "Conversion::Project"
      redirect_to project_conversion_tasks_path(@project)
    when "Transfer::Project"
      render "transfers/projects/show"
    end
  end

  def index
    authorize Project, :index?

    redirect_to in_progress_user_projects_path
  end
end

class ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def show
    @project = Project.find(params[:id])
    authorize @project

    redirect_to project_tasks_path(@project)
  end

  def index
    authorize Project, :index?

    redirect_to in_progress_user_projects_path
  end
end

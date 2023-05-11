class ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def show
    @project = Project.find(params[:id])
    authorize @project

    redirect_to project_conversion_tasks_path(@project)
  end
end

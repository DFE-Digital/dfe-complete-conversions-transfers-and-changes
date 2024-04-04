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

    redirect_to in_progress_your_projects_path
  end

  def confirm_delete
    authorize Project, :delete?

    @project = Project.find(params[:id])
  end

  def delete
    authorize Project, :delete?

    @project = Project.find(params[:id])
    @project.update(state: :deleted)
    redirect_to all_in_progress_projects_path, notice: I18n.t("project.delete.success")
  end
end

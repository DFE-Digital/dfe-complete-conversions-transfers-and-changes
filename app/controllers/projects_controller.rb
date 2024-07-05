class ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def new
    authorize Project
    @new_project_form = NewProjectForm.new
  end

  def create
    authorize Project

    case new_project_params["project_type"]
    when "conversion"
      redirect_to conversions_new_path
    when "transfer"
      redirect_to transfers_new_path
    when "form_a_mat_conversion"
      redirect_to conversions_new_mat_path
    when "form_a_mat_transfer"
      redirect_to transfers_new_mat_path
    else
      not_found_error
    end
  end

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
    redirect_to all_all_in_progress_projects_path, notice: I18n.t("project.delete.success")
  end

  private def new_project_params
    params.require(:new_project_form).permit(:project_type)
  end
end

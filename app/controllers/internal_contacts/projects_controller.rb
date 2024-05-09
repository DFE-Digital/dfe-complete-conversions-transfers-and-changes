class InternalContacts::ProjectsController < ApplicationController
  before_action :find_project, :authorize_user
  after_action :verify_authorized

  def edit_assigned_user
    @edit_form = InternalContacts::EditAssignedUserForm.new_from_project(@project)
    session[:return_url] = request.referrer
    set_return_url
  end

  def update_assigned_user
    @edit_form = InternalContacts::EditAssignedUserForm.new({email: edit_assigned_user_params[:email], project: @project})
    set_return_url

    if @edit_form.update
      redirect_to @return_url, notice: I18n.t("project.assign.assigned_to.success")
    else
      render :edit_assigned_user
    end
  end

  def edit_added_by_user
    @edit_form = InternalContacts::EditAddedByUserForm.new_from_project(@project)
    session[:return_url] = request.referrer
  end

  def update_added_by_user
    @edit_form = InternalContacts::EditAddedByUserForm.new({email: edit_added_by_user_params[:email], project: @project})

    if @edit_form.update
      redirect_to project_internal_contacts_path(@project), notice: I18n.t("project.edit.added_by.success")
    else
      render :edit_added_by_user
    end
  end

  def edit_team
  end

  def update_team
    @project.update(edit_conversion_team_params || edit_transfer_team_params)
    redirect_to project_internal_contacts_path(@project), notice: I18n.t("project.assign.assigned_to_team.success")
  end

  private def set_return_url
    @return_url = url_from(session[:return_url]) || project_internal_contacts_path(@project)
  end

  private def edit_assigned_user_params
    params.require(:internal_contacts_edit_assigned_user_form).permit(:email)
  end

  private def edit_added_by_user_params
    params.require(:internal_contacts_edit_added_by_user_form).permit(:email)
  end

  private def edit_conversion_team_params
    params.require(:conversion_project).permit(:team) if params[:conversion_project].present?
  end

  private def edit_transfer_team_params
    params.require(:transfer_project).permit(:team) if params[:transfer_project].present?
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def authorize_user
    authorize :assignment
  end
end

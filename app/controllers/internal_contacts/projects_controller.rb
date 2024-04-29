class InternalContacts::ProjectsController < ApplicationController
  before_action :find_project, :authorize_user
  after_action :verify_authorized

  def edit_assigned_user
    @edit_form = InternalContacts::EditAssignedUserForm.new_from_project(@project)
    session[:return_url] = request.referrer
    set_return_url
  end

  def update_assigned_user
    @edit_form = InternalContacts::EditAssignedUserForm.new({email: email_param, project: @project})
    set_return_url

    if @edit_form.update
      redirect_to @return_url, notice: I18n.t("project.assign.assigned_to.success")
    else
      render :edit_assigned_user
    end
  end

  private def set_return_url
    @return_url = url_from(session[:return_url]) || project_internal_contacts_path(@project)
  end

  private def email_param
    form_params[:email]
  end

  private def form_params
    params.require(:internal_contacts_edit_assigned_user_form).permit(:email)
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end

  private def authorize_user
    authorize :assignment
  end
end

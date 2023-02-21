class AssignmentsController < ApplicationController
  before_action :find_project
  before_action :authorize_user
  after_action :verify_authorized

  def assign_team_leader
    @team_leaders = User.team_leaders
  end

  def update_team_leader
    @project.update(team_leader_params)

    redirect_to helpers.path_to_project_internal_contacts(@project), notice: t("project.assign.team_leader.success")
  end

  def assign_regional_delivery_officer
    @regional_delivery_officers = User.regional_delivery_officers
  end

  def update_regional_delivery_officer
    @project.update(regional_delivery_officer_params)

    redirect_to helpers.path_to_project_internal_contacts(@project), notice: t("project.assign.regional_delivery_officer.success")
  end

  def assign_caseworker
    @caseworkers = User.caseworkers
  end

  def update_caseworker
    @project.update(caseworker_assigned_at: DateTime.now) if @project.caseworker_assigned_at.nil?
    @project.update(caseworker_params)

    CaseworkerMailer.caseworker_assigned_notification(@project.caseworker, @project).deliver_later

    redirect_to helpers.path_to_project_internal_contacts(@project), notice: t("project.assign.caseworker.success")
  end

  def assign_assigned_to
    @all_eligible_users = helpers.all_eligible_users
  end

  def update_assigned_to
    @project.update(assigned_to_params.except(:return_to))
    return_to = assigned_to_params[:return_to] || helpers.path_to_project_internal_contacts(@project)

    redirect_to return_to, notice: t("project.assign.assigned_to.success")
  end

  private def authorize_user
    authorize :assignment
  end

  private def team_leader_params
    params.require(:conversion_project).permit(:team_leader_id)
  end

  private def regional_delivery_officer_params
    params.require(:conversion_project).permit(:regional_delivery_officer_id)
  end

  private def caseworker_params
    params.require(:conversion_project).permit(:caseworker_id)
  end

  private def assigned_to_params
    params.require(:conversion_project).permit(:assigned_to_id, :return_to)
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end
end

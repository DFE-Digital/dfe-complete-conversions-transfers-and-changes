class AssignmentsController < ApplicationController
  before_action :find_project
  before_action :authorize_user
  after_action :verify_authorized

  def assign_team_leader
    @team_leaders = User.team_leaders
  end

  def update_team_leader
    @project.update(team_leader_params)

    redirect_to project_internal_contacts_path(@project), notice: I18n.t("project.assign.team_leader.success")
  end

  def assign_regional_delivery_officer
    @regional_delivery_officers = User.regional_delivery_officers
  end

  def update_regional_delivery_officer
    authorize @project, :update_regional_delivery_officer?
    @project.update(regional_delivery_officer_params)

    redirect_to project_internal_contacts_path(@project), notice: I18n.t("project.assign.regional_delivery_officer.success")
  end

  def assign_team
  end

  def update_team
    authorize @project, :update_assigned_to?

    @project.update(assigned_to_team_params)
    redirect_to project_internal_contacts_path(@project), notice: I18n.t("project.assign.assigned_to_team.success")
  end

  private def authorize_user
    authorize :assignment
  end

  private def team_leader_params
    return params.require(:conversion_project).permit(:team_leader_id) if params[:conversion_project].present?
    params.require(:transfer_project).permit(:team_leader_id) if params[:transfer_project].present?
  end

  private def regional_delivery_officer_params
    return params.require(:conversion_project).permit(:regional_delivery_officer_id) if params[:conversion_project].present?
    params.require(:transfer_project).permit(:regional_delivery_officer_id) if params[:transfer_project].present?
  end

  private def assigned_to_team_params
    return params.require(:transfer_project).permit(:team) if params[:transfer_project].present?
    params.require(:conversion_project).permit(:team) if params[:conversion_project].present?
  end

  private def find_project
    @project = Project.find(params[:project_id])
  end
end

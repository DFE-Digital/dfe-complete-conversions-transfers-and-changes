class AssignmentsController < ApplicationController
  def assign_team_leader
    @team_leaders = User.team_leaders
    @project = Project.find(params[:project_id])
  end

  def update_team_leader
    @project = Project.find(params[:project_id])
    @project.update(team_leader_params)

    redirect_to project_information_path(project), notice: t("project.assign.team_leader.success")
  end

  private def team_leader_params
    params.require(:project).permit(:team_leader_id)
  end
end

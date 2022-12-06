class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.open))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)
  end

  def completed
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.completed))
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
    redirect_to project_conversion_voluntary_task_list_index_path(@project)
  end

  private def notify_team_leaders
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_project_created(team_leader, @project).deliver_later
    end
  end
end

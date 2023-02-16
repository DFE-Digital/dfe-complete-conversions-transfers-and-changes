class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.open.includes(:assigned_to)))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)
  end

  def completed
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.completed))
  end

  def unassigned
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.unassigned_to_user.assigned_to_regional_caseworker_team))
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
  end
end

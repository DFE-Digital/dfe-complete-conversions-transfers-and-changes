class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.in_progress.includes(:assigned_to)))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def all_in_progress
    authorize Project
    @pager, @projects = pagy(Project.in_progress.includes(:assigned_to))
  end

  def regional_casework_services_in_progress
    authorize Project
    @pager, @projects = pagy(Project.assigned_to_regional_caseworker_team.in_progress.includes(:assigned_to))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def regional_casework_services_completed
    authorize Project
    @pager, @projects = pagy(Project.assigned_to_regional_caseworker_team.completed)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def all_completed
    authorize Project
    @pagy, @projects = pagy(Project.completed)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def user_in_progress
    authorize Project
    @pager, @projects = pagy(Project.assigned_to(current_user).in_progress.includes(:assigned_to))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def user_completed
    authorize Project
    @pagy, @projects = pagy(Project.assigned_to(current_user).completed)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def unassigned
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.unassigned_to_user.assigned_to_regional_caseworker_team))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def show
    @project = Project.find(params[:id])
    authorize @project
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcher.new.call(projects)
  end

  private def pre_fetch_incoming_trusts(projects)
    IncomingTrustsFetcher.new.call(projects)
  end
end

class User::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def in_progress
    authorize Project, :index?
    @pager, @projects = pagy(Project.assigned_to(current_user).in_progress.includes(:assigned_to), items: 10)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def added_by
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.added_by(current_user).not_completed.by_conversion_date.includes(:assigned_to))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def completed
    authorize Project, :index?
    @pager, @projects = pagy(Project.assigned_to(current_user).completed)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcherService.new(projects).call!
  end

  private def pre_fetch_incoming_trusts(projects)
    TrustsFetcherService.new(projects).call!
  end
end

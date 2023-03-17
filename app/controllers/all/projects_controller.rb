class All::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def in_progress
    authorize Project, :index?
    @pager, @projects = pagy(Project.in_progress.includes(:assigned_to))
  end

  def completed
    authorize Project, :index?
    @pager, @projects = pagy(Project.completed)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcher.new.call(projects)
  end

  private def pre_fetch_incoming_trusts(projects)
    IncomingTrustsFetcher.new.call(projects)
  end
end

class All::InProgress::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.in_progress.includes(:assigned_to))
  end

  def voluntary
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.in_progress.voluntary.includes(:assigned_to))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def sponsored
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.in_progress.sponsored.includes(:assigned_to))

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

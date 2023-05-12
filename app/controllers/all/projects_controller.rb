class All::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def new
    authorize Project, :index?
    @pager, @projects = pagy(Project.not_completed.no_academy_urn.by_conversion_date)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def with_academy_urn
    authorize Project, :index?
    @pager, @projects = pagy(Project.not_completed.with_academy_urn.by_conversion_date)

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

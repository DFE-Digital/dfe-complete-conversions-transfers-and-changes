class ServiceSupport::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def without_academy_urn
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.not_completed.no_academy_urn.by_conversion_date)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def with_academy_urn
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.not_completed.with_academy_urn.by_conversion_date)

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

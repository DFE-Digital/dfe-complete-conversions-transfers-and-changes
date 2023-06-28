class All::Trusts::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @trusts = pagy_array(ByTrustProjectFetcherService.new.call)
  end

  def show
    authorize Project, :index?
    ukprn = params[:trust_ukprn]
    @pager, @projects = pagy(Conversion::Project.not_completed.by_trust_ukprn(ukprn).by_conversion_date)

    pre_fetch_establishments(@projects)
    @trust = Api::AcademiesApi::Client.new.get_trust(ukprn).object
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcherService.new(projects).call!
  end
end

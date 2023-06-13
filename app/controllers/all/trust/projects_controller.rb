class All::Trust::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def by_trust
    authorize Project, :index?
    ukprn = params[:trust_ukprn]
    @pager, @projects = pagy(Conversion::Project.by_trust_ukprn(ukprn).by_conversion_date)

    pre_fetch_establishments(@projects)
    @trust = Api::AcademiesApi::Client.new.get_trust(ukprn).object
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcher.new.call(projects)
  end
end

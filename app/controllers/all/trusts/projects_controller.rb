class All::Trusts::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @trusts = pagy_array(ByTrustProjectFetcherService.new.call)
  end

  def show
    authorize Project, :index?

    @trust = Api::AcademiesApi::Client.new.get_trust(incoming_trust_ukprn).object
    @pager, @projects = pagy(Project.active.by_trust_ukprn(@trust.ukprn).ordered_by_significant_date.includes(:assigned_to))

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  private def incoming_trust_ukprn
    params[:trust_ukprn]
  end
end

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
    @pager, @projects = pagy(
      Project.active.by_trust_ukprn(@trust.ukprn).ordered_by_significant_date.includes(:assigned_to)
    )

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def show_by_reference
    authorize Project, :index?

    @trust = build_trust_from_reference_number(trust_reference_number)
    @pager, @projects = pagy(
      Project.active.where(
        new_trust_reference_number: trust_reference_number
      ).ordered_by_significant_date.includes(:assigned_to)
    )

    AcademiesApiPreFetcherService.new.call!(@projects)
    render "show"
  end

  private def incoming_trust_ukprn
    params[:trust_ukprn]
  end

  private def trust_reference_number
    params[:trust_reference_number]
  end

  private def build_trust_from_reference_number(reference)
    project = Project.find_by_new_trust_reference_number!(reference)

    Api::AcademiesApi::Trust.new.from_hash(
      {referenceNumber: project.new_trust_reference_number, name: project.new_trust_name}
    )
  end
end

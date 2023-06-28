class All::Regions::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @regions = ByRegionProjectFetcherService.new.call
  end

  def show
    authorize Project, :index?
    return not_found_error unless Project.regions.include?(region)

    @region = region
    @pager, @projects = pagy(Conversion::Project.not_completed.by_region(region).by_conversion_date)

    pre_fetch_establishments(@projects)
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcher.new.call(projects)
  end

  private def region
    params[:region_id]
  end
end

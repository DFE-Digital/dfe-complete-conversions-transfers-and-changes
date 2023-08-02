class All::Regions::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @regions = ByRegionProjectFetcherService.new.project_counts
  end

  def show
    authorize Project, :index?
    return not_found_error unless Project.regions.include?(region)

    @region = region
    @pager, @projects = pagy(Project.not_completed.by_region(region).ordered_by_significant_date.includes(:assigned_to))
    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  private def region
    params[:region_id]
  end
end

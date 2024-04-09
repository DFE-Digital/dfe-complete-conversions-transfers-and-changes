class ServiceSupport::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def without_academy_urn
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.active.no_academy_urn.by_conversion_date)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def with_academy_urn
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.active.with_academy_urn.by_conversion_date)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

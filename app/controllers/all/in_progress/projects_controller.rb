class All::InProgress::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?

    @pager, @projects = pagy(Conversion::Project.in_progress.includes(:assigned_to).ordered_by_significant_date)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

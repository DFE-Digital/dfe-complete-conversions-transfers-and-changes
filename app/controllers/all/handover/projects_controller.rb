class All::Handover::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :handover?

    @pager, @projects = pagy(Project.inactive.ordered_by_significant_date)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

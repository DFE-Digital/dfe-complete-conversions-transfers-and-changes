class All::Completed::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @projects = pagy(Project.completed)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

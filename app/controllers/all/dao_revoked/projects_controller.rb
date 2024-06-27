class All::DaoRevoked::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @projects = pagy(Project.dao_revoked.includes(:dao_revocation))

    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

class All::LocalAuthorities::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @local_authorities = ByLocalAuthorityProjectFetcherService.new.call
  end
end

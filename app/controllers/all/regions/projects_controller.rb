class All::Regions::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @regions = ByRegionProjectFetcherService.new.call
  end
end

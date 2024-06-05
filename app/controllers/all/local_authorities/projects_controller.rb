class All::LocalAuthorities::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @local_authorities = pagy_array(ByLocalAuthorityProjectFetcherService.new.local_authorities_with_projects)
  end

  def show
    authorize Project, :index?
    @local_authority = LocalAuthority.find_by!(code: local_authority_code)
    @pager, @projects = pagy_array(ByLocalAuthorityProjectFetcherService.new.projects_for_local_authority(@local_authority.code))
  end

  private def local_authority_code
    params[:local_authority_id]
  end
end

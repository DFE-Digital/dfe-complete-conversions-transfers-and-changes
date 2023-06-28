class All::LocalAuthorities::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @local_authorities = pagy_array(ByLocalAuthorityProjectFetcherService.new.call)
  end

  def show
    authorize Project, :index?
    @local_authority = LocalAuthority.find_by!(code: local_authority_code)
    @projects = projects_for_local_authority(local_authority_code)
  end

  private def local_authority_code
    params[:local_authority_id]
  end

  private def projects_for_local_authority(local_authority_code)
    projects = Project.not_completed
    pre_fetch_establishments(projects)
    @projects = projects.to_a.select { |p| p.establishment.local_authority_code == local_authority_code }
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcher.new.call(projects)
  end
end

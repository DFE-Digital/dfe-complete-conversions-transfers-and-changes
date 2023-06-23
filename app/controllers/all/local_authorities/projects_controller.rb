class All::LocalAuthorities::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @local_authorities = ByLocalAuthorityProjectFetcherService.new.call
  end

  def show
    authorize Project, :index?
    @local_authority = LocalAuthority.find_by!(code: local_authority_code)
    @projects = Project.not_completed.to_a.select { |p| p.establishment.local_authority_code == local_authority_code }

    pre_fetch_establishments(@projects)
  end

  private def local_authority_code
    params[:local_authority_id]
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcher.new.call(projects)
  end
end

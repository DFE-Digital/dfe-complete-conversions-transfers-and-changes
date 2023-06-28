class Regional::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def in_progress
    authorize Project, :index?
    @pager, @projects = pagy(Project.not_assigned_to_regional_caseworker_team.in_progress.includes(:assigned_to))

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def in_progress_by_region
    authorize Project, :index?
    return not_found_error unless valid_region?

    @pager, @projects = pagy(Project.not_assigned_to_regional_caseworker_team.by_region(region).in_progress.includes(:assigned_to))
    @region = region
    @region_string = I18n.t("project.region.#{region}")

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def completed
    authorize Project, :index?
    @pager, @projects = pagy(Project.not_assigned_to_regional_caseworker_team.completed)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  def completed_by_region
    authorize Project, :index?
    return not_found_error unless valid_region?

    @pager, @projects = pagy(Project.not_assigned_to_regional_caseworker_team.by_region(region).completed)
    @region = region
    @region_string = I18n.t("project.region.#{region}")

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcherService.new(projects).call!
  end

  private def pre_fetch_incoming_trusts(projects)
    TrustsFetcherService.new(projects).call!
  end

  private def valid_region?
    Project.regions.include?(region)
  end

  private def region
    params[:region].tr("-", "_")
  end
end

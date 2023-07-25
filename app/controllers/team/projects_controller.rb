class Team::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def in_progress
    authorize Project, :index?
    @pager, @projects = pagy_array(ByTeamProjectFetcherService.new(current_user.team).in_progress)
  end

  def completed
    authorize Project, :index?
    @pager, @projects = pagy_array(ByTeamProjectFetcherService.new(current_user.team).completed)
  end

  def unassigned
    authorize Project, :unassigned?

    @pager, @projects = pagy_array(ByTeamProjectFetcherService.new(current_user.team).unassigned)
  end

  def handed_over
    begin
      authorize Project, :handed_over?
    rescue Pundit::NotAuthorizedError
      return head(:not_found)
    end

    @current_users_team = current_user.team
    @pager, @projects = pagy(ByRegionProjectFetcherService.new.regional_casework_services_projects(@current_users_team))

    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

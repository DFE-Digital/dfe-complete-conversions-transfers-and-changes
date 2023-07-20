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
end

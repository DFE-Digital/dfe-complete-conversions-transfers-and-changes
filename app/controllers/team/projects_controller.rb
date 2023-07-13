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

  def users
    authorize Project, :index?

    @pager, @users = pagy_array(ByTeamProjectFetcherService.new(current_user.team).users)
  end

  def by_user
    authorize Project, :index?

    user_id = params[:user_id]
    @user = User.find(user_id)
    @pager, @projects = pagy(Conversion::Project.assigned_to(@user)
                                                .in_progress
                                                .by_conversion_date)

    pre_fetch_establishments(@projects)
    pre_fetch_incoming_trusts(@projects)
  end

  private def pre_fetch_establishments(projects)
    EstablishmentsFetcherService.new(projects).call!
  end

  private def pre_fetch_incoming_trusts(projects)
    TrustsFetcherService.new(projects).call!
  end
end

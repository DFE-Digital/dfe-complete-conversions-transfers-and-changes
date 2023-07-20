class Team::Users::ProjectsController < ApplicationController
  def index
    authorize Project, :index?

    @pager, @users = pagy_array(ByTeamProjectFetcherService.new(current_user.team).users)
  end

  def show
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

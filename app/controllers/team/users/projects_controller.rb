class Team::Users::ProjectsController < ApplicationController
  def index
    authorize Project, :index?

    @pager, @users = pagy_array(ByTeamProjectFetcherService.new(current_user.team).users)
  end

  def show
    authorize Project, :index?

    @user = User.find(user_id)
    @pager, @projects = pagy(Project.assigned_to(@user).in_progress.ordered_by_significant_date)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  private def user_id
    params[:user_id]
  end
end

class All::Users::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @pager, @users = pagy_array(ByUserProjectFetcherService.new.call)
  end

  def show
    authorize Project, :index?
    @user = User.find(user_id)
    @pager, @projects = pagy(Project.active.assigned_to(@user))
  end

  private def user_id
    params[:user_id]
  end
end

class All::Users::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project, :index?
    @users = ByUserProjectFetcherService.new.call
  end

  def show
    authorize Project, :index?
    @user = User.find(user_id)
    @projects = Project.not_completed.assigned_to(@user)
  end

  private def user_id
    params[:user_id]
  end
end

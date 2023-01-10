class ProjectsController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.open.includes(:details)))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)
  end

  def completed
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.completed.includes(:details)))
  end

  def show
    @project = Project.includes(sections: [:tasks]).find(params[:id])
    authorize @project
  end

  private def not_found_error
    redirect_to "/404", status: :not_found
  end
end

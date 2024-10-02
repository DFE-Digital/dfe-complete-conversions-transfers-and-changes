class Your::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def in_progress
    authorize Project, :index?
    @pager, @projects = pagy(Project.assigned_to(current_user).in_progress.ordered_by_significant_date, items: 10)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def added_by
    authorize Project, :index?
    @pager, @projects = pagy(Project.added_by(current_user).active.ordered_by_significant_date.includes(:assigned_to))

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def completed
    authorize Project, :index?
    @pager, @projects = pagy(Project.assigned_to(current_user).completed.ordered_by_completed_date)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

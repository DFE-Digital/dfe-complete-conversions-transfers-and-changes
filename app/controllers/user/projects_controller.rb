class User::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def in_progress
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.assigned_to(current_user).in_progress.includes(:assigned_to).ordered_by_significant_date, items: 10)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def added_by
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.added_by(current_user).not_completed.by_conversion_date.includes(:assigned_to))

    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def completed
    authorize Project, :index?
    @pager, @projects = pagy(Conversion::Project.assigned_to(current_user).completed)

    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

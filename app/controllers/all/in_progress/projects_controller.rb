class All::InProgress::ProjectsController < ApplicationController
  after_action :verify_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def all_index
    authorize Project, :index?

    @pager, @projects = pagy(Project.in_progress.includes(:assigned_to).ordered_by_significant_date)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def conversions_index
    authorize Project, :index?

    @pager, @projects = pagy(Project.conversions.in_progress.includes(:assigned_to).ordered_by_significant_date)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def transfers_index
    authorize Project, :index?

    @pager, @projects = pagy(Project.transfers.in_progress.includes(:assigned_to).ordered_by_significant_date)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def form_a_multi_academy_trust_index
    authorize Project, :index?

    @pager, @project_groups = pagy_array(FormAMultiAcademyTrust::ProjectGroupFetcherService.new.call)
  end
end

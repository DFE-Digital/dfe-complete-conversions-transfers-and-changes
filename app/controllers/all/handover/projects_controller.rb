class All::Handover::ProjectsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize Project, :handover?

    @pager, @projects = pagy(Project.inactive.ordered_by_significant_date)
    AcademiesApiPreFetcherService.new.call!(@projects)
  end
end

class All::Handover::ProjectsController < ApplicationController
  after_action :verify_authorized

  def index
    authorize Project, :handover?

    @pager, @projects = pagy(Project.inactive.ordered_by_significant_date)
    @enable_search = @pager.pages > 1
    AcademiesApiPreFetcherService.new.call!(@projects)
  end

  def search
    authorize Project, :handover?

    @search_result = Project.inactive.find_by(urn: params[:urn_query])

    if @search_result.blank?
      @failed_search_urn = params[:urn_query]
      flash[:error] = "No project to be handed over with URN #{params[:urn_query]} was found"
      redirect_to action: :index
    else
      render :index
    end
  end
end

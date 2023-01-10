class Conversions::Involuntary::ProjectsController < Conversions::ProjectsController
  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.conversions_involuntary.open.includes(:details)))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)

    render "/conversions/involuntary/index"
  end

  def show
    @project = Project.conversions_involuntary.includes(sections: [:tasks]).find(params[:id])
    authorize @project
  end
end

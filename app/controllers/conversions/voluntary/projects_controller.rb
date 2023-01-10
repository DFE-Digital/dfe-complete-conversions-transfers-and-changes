class Conversions::Voluntary::ProjectsController < Conversions::ProjectsController
  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.conversions_voluntary.open.includes(:details)))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)

    render "/conversions/voluntary/index"
  end

  def show
    @project = Project.conversions_voluntary.includes(sections: [:tasks]).find(params[:id])
    authorize @project
  end
end

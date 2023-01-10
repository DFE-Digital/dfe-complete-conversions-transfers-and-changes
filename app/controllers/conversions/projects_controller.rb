class Conversions::ProjectsController < ProjectsController
  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.conversions.open.includes(:details)))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)

    render "/conversions/index"
  end
end

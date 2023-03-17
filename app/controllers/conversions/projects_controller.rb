class Conversions::ProjectsController < ProjectsController
  def index
    authorize Project
    @pagy, @projects = pagy(policy_scope(Project.conversions.in_progress))

    EstablishmentsFetcher.new.call(@projects)
    IncomingTrustsFetcher.new.call(@projects)

    render "/conversions/index"
  end
end

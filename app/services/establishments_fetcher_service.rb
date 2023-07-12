class EstablishmentsFetcherService
  def initialize(projects)
    @establishments = []
    @projects = projects
  end

  def call!
    return if @projects.nil? || @projects.empty?
    raise ArgumentError.new("You must pass in the result of an ActiveRecord query (ActiveRecord::Relation)") unless @projects.is_a?(ActiveRecord::Relation)

    @projects.in_batches(of: 20) do |batch_of_projects|
      urns = batch_of_projects.pluck(:urn)
      response = Api::AcademiesApi::Client.new.get_establishments(urns)

      if response.error.nil?
        @establishments.concat(response.object)
      else
        track_error(response.error)
        raise Api::AcademiesApi::Client::Error.new
      end
    end

    @projects.each do |project|
      project.establishment = @establishments.find { |establishment| establishment.urn == project.urn.to_s }
    end
  end

  private def track_error(error_message)
    if ENV.fetch("APPLICATION_INSIGHTS_KEY", nil)
      tc = ApplicationInsights::TelemetryClient.new(ENV.fetch("APPLICATION_INSIGHTS_KEY"))
      tc.track_event(error_message)
      tc.flush
    end
  end
end

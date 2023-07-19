class EstablishmentsFetcherService
  def initialize(projects)
    @establishments = []
    @projects = projects
  end

  def call!
    paged!
  end

  def paged!
    return if @projects.nil? || @projects.empty?
    raise ArgumentError.new("We don't recommend trying to prefetch more than 20 records") if @projects.count > 20

    urns = @projects.pluck(:urn)
    response = Api::AcademiesApi::Client.new.get_establishments(urns)

    if response.error.nil?
      @establishments.concat(response.object)
    else
      track_error(response.error)
      raise Api::AcademiesApi::Client::Error.new
    end
    populate_projects_with_establishments
  end

  def batched!
    return if @projects.nil? || @projects.empty?
    raise ArgumentError.new("You must pass in the result of an ActiveRecord query (ActiveRecord::Relation)") unless @projects.is_a?(ActiveRecord::Relation)

    @projects.find_in_batches(batch_size: 10) do |batch_of_projects|
      urns = batch_of_projects.pluck(:urn)
      response = Api::AcademiesApi::Client.new.get_establishments(urns)

      if response.error.nil?
        @establishments.concat(response.object)
      else
        track_error(response.error)
        raise Api::AcademiesApi::Client::Error.new
      end
    end
    populate_projects_with_establishments
  end

  private def populate_projects_with_establishments
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

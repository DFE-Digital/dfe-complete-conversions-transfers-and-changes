class TrustsFetcherService
  def initialize(projects)
    @trusts = []
    @projects = projects
  end

  def call!
    paged!
  end

  def paged!
    return if @projects.nil? || @projects.empty?
    raise ArgumentError.new("We don't recommend trying to prefetch more than 20 records") if @projects.count > 20

    ids = @projects.pluck(:incoming_trust_ukprn)
    response = Api::AcademiesApi::Client.new.get_trusts(ids)

    if response.error.nil?
      @trusts.concat(response.object)
    else
      track_error(response.error)
      raise Api::AcademiesApi::Client::Error.new
    end
    populate_projects_with_trusts
  end

  def batched!
    return if @projects.nil? || @projects.empty?
    raise ArgumentError.new("You must pass in the result of an ActiveRecord query (ActiveRecord::Relation)") unless @projects.is_a?(ActiveRecord::Relation)

    @projects.find_in_batches(batch_size: 10) do |batch_of_projects|
      ukprns = batch_of_projects.pluck(:incoming_trust_ukprn)
      response = Api::AcademiesApi::Client.new.get_trusts(ukprns)

      if response.error.nil?
        @trusts.concat(response.object)
      else
        track_error(response.error)
        raise Api::AcademiesApi::Client::Error.new
      end
    end
    populate_projects_with_trusts
  end

  private def populate_projects_with_trusts
    @projects.each do |project|
      project.incoming_trust = @trusts.find { |trust| trust.ukprn == project.incoming_trust_ukprn.to_s }
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

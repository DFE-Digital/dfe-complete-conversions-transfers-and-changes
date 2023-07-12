class TrustsFetcherService
  def initialize(projects)
    @trusts = []
    @projects = projects
  end

  def call!
    return if @projects.nil? || @projects.empty?
    raise ArgumentError.new("You must pass in the result of an ActiveRecord query (ActiveRecord::Relation)") unless @projects.is_a?(ActiveRecord::Relation)

    @projects.in_batches(of: 20) do |batch_of_projects|
      ukprns = batch_of_projects.pluck(:incoming_trust_ukprn)
      response = Api::AcademiesApi::Client.new.get_trusts(ukprns)

      if response.error.nil?
        @trusts.concat(response.object)
      else
        track_error(response.error)
        raise Api::AcademiesApi::Client::Error.new
      end
    end

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

class TrustsFetcherService
  def initialize(projects)
    @trusts = []
    @projects = projects
  end

  def call!
    return unless @projects&.any?
    raise ArgumentError.new("You must pass in the result of an ActiveRecord query (ActiveRecord::Relation)") unless @projects.is_a?(ActiveRecord::Relation)

    @projects.in_batches(of: 20) do |batch_of_projects|
      ukprns = batch_of_projects.pluck(:incoming_trust_ukprn)
      @trusts += Api::AcademiesApi::Client.new.get_trusts(ukprns).object
    end

    @projects.each do |project|
      project.incoming_trust = @trusts.find { |trust| trust.ukprn == project.incoming_trust_ukprn.to_s }
    end
  end
end

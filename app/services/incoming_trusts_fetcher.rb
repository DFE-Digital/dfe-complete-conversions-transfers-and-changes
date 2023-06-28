class IncomingTrustsFetcher
  def initialize
    @trusts = []
  end

  def call(projects)
    return unless projects&.any?
    raise ArgumentError unless projects.is_a?(ActiveRecord::Relation)

    projects.in_batches(of: 20) do |batch_of_projects|
      ukprns = batch_of_projects.pluck(:incoming_trust_ukprn)
      @trusts += Api::AcademiesApi::Client.new.get_trusts(ukprns).object
    end

    projects.each do |project|
      project.incoming_trust = @trusts.find { |trust| trust.ukprn == project.incoming_trust_ukprn.to_s }
    end
  end
end

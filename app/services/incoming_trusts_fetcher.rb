class IncomingTrustsFetcher
  def call(projects)
    return unless projects&.any?

    ukprns = projects.map(&:incoming_trust_ukprn)
    trusts = Api::AcademiesApi::Client.new.get_trusts(ukprns).object

    projects.each do |project|
      project.incoming_trust = trusts.find { |trust| trust.ukprn == project.incoming_trust_ukprn.to_s }
    end
  end
end

class ProjectGroupPreFetchingService
  include ApplicationInsightsEventTrackable

  def initialize(project_groups)
    @project_groups = project_groups
  end

  def pre_fetch!
    all_trust_ukprns = @project_groups.map(&:trust_ukprn)

    all_trusts = fetch_trusts(all_trust_ukprns)

    @project_groups.each do |project_group|
      project_group.trust = all_trusts.find { |t| t.ukprn.to_i == project_group.trust_ukprn.to_i }
    end

    @project_groups
  end

  private def fetch_trusts(ukprns)
    trusts = []
    response = Api::AcademiesApi::Client.new.get_trusts(ukprns)

    if response.error.nil?
      trusts.concat(response.object)
    else
      track_event(response.error.message)
    end
    trusts
  end
end

module ProjectHelpers
  def create_unassigned_project(urn: 123456, trust_ukprn: 12345678)
    project = build(:project, urn: urn, trust_ukprn: trust_ukprn, team_leader: nil)
    mock_successful_api_responses(urn: project.urn, ukprn: project.trust_ukprn)
    project.save!
    project
  end
end

module ProjectHelpers
  def create_unassigned_project(urn: 123456, incoming_trust_ukprn: 12345678)
    project = build(:conversion_project, urn: urn, incoming_trust_ukprn: incoming_trust_ukprn, team_leader: nil)
    mock_successful_api_responses(urn: project.urn, ukprn: project.incoming_trust_ukprn)
    project.save!
    project
  end
end

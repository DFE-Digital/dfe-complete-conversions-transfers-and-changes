module ProjectHelpers
  def create_unassigned_project(urn: 123456, incoming_trust_ukprn: 12345678)
    project = build(:project, urn: urn, incoming_trust_ukprn: incoming_trust_ukprn)
    mock_successful_api_responses(urn: project.urn, ukprn: project.incoming_trust_ukprn)
    project.save!
    project
  end
end

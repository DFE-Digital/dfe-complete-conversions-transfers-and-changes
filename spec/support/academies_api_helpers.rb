module AcademiesApiHelpers
  def mock_successful_api_responses(urn:)
    mock_successful_api_establishment_response(urn:)
    mock_successful_api_conversion_project_response(urn:)
  end

  def mock_successful_api_establishment_response(urn:, establishment: nil)
    establishment = build(:academies_api_establishment) if establishment.nil?

    fake_result = AcademiesApi::Client::Result.new(establishment, nil)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(urn).and_return(fake_result)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_api_conversion_project_response(urn:, conversion_project: nil)
    conversion_project = build(:academies_api_conversion_project) if conversion_project.nil?

    fake_result = AcademiesApi::Client::Result.new(conversion_project, nil)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_conversion_project).with(urn).and_return(fake_result)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end
end

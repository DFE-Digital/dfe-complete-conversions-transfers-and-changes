module AcademiesApiHelpers
  def mock_successful_api_calls(establishment:, trust:)
    fake_client = double(AcademiesApi::Client,
      get_establishments: AcademiesApi::Client::Result.new([establishment], nil),
      get_establishment: AcademiesApi::Client::Result.new(establishment, nil),
      get_trusts: AcademiesApi::Client::Result.new([trust], nil),
      get_trust: AcademiesApi::Client::Result.new(trust, nil))

    allow(AcademiesApi::Client).to receive(:new).and_return(fake_client)
  end

  def mock_successful_api_responses(urn:, ukprn:)
    mock_successful_api_establishment_response(urn:)
    mock_successful_api_trust_response(ukprn:)
  end

  def mock_successful_api_establishment_response(urn:, establishment: nil)
    establishment = build(:academies_api_establishment) if establishment.nil?

    fake_result = AcademiesApi::Client::Result.new(establishment, nil)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(urn).and_return(fake_result)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_api_trust_response(ukprn:, trust: nil)
    trust = build(:academies_api_trust) if trust.nil?

    fake_result = AcademiesApi::Client::Result.new(trust, nil)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_trust).with(ukprn).and_return(fake_result)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_timeout_api_responses(urn:, ukprn:)
    mock_timeout_api_establishment_response(urn:)
    mock_timeout_api_trust_response(ukprn:)
  end

  def mock_timeout_api_establishment_response(urn:)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(urn).and_raise(AcademiesApi::Client::Error)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_timeout_api_trust_response(ukprn:)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_trust).with(ukprn).and_raise(AcademiesApi::Client::Error)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end
end

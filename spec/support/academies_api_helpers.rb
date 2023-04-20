module AcademiesApiHelpers
  def mock_successful_api_calls(establishment:, trust:)
    fake_client = double(Api::AcademiesApi::Client,
      get_establishments: Api::AcademiesApi::Client::Result.new([establishment], nil),
      get_establishment: Api::AcademiesApi::Client::Result.new(establishment, nil),
      get_trusts: Api::AcademiesApi::Client::Result.new([trust], nil),
      get_trust: Api::AcademiesApi::Client::Result.new(trust, nil))

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)
  end

  def mock_successful_api_response_to_create_any_project
    mock_successful_api_establishment_response(urn: any_args)
    mock_successful_api_trust_response(ukprn: any_args)
  end

  def mock_successful_api_responses(urn:, ukprn:)
    mock_successful_api_establishment_response(urn:)
    mock_successful_api_trust_response(ukprn:)
  end

  def mock_successful_api_establishment_response(urn:, establishment: nil)
    establishment = build(:academies_api_establishment) if establishment.nil?

    fake_result = Api::AcademiesApi::Client::Result.new(establishment, nil)
    test_client = Api::AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(urn).and_return(fake_result)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_successful_api_trust_response(ukprn:, trust: nil)
    trust = build(:academies_api_trust) if trust.nil?

    fake_result = Api::AcademiesApi::Client::Result.new(trust, nil)
    test_client = Api::AcademiesApi::Client.new

    allow(test_client).to receive(:get_trust).with(ukprn).and_return(fake_result)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_pre_fetched_api_responses_for_any_establishment_and_trust
    fake_establishment_fetcher = double(EstablishmentsFetcher)
    fake_trust_fetcher = double(IncomingTrustsFetcher)
    allow(EstablishmentsFetcher).to receive(:new).and_return(fake_establishment_fetcher)
    allow(IncomingTrustsFetcher).to receive(:new).and_return(fake_establishment_fetcher)

    allow(fake_establishment_fetcher).to receive(:call).and_return([])
    allow(fake_trust_fetcher).to receive(:call).and_return([])
  end

  def mock_timeout_api_responses(urn:, ukprn:)
    mock_timeout_api_establishment_response(urn:)
    mock_timeout_api_trust_response(ukprn:)
  end

  def mock_establishment_not_found(urn:)
    mock_client = Api::AcademiesApi::Client.new
    not_found_result = Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError)
    allow(mock_client).to receive(:get_establishment).with(urn).and_return(not_found_result)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(mock_client)
  end

  def mock_timeout_api_establishment_response(urn:)
    test_client = Api::AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(urn).and_raise(Api::AcademiesApi::Client::Error)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_timeout_api_trust_response(ukprn:)
    test_client = Api::AcademiesApi::Client.new

    allow(test_client).to receive(:get_trust).with(ukprn).and_raise(Api::AcademiesApi::Client::Error)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_unauthorised_api_responses(urn:, ukprn:)
    test_client = Api::AcademiesApi::Client.new

    allow(test_client).to receive(:get_trust).with(ukprn).and_raise(Api::AcademiesApi::Client::UnauthorisedError)
    allow(test_client).to receive(:get_establishment).with(ukprn).and_raise(Api::AcademiesApi::Client::UnauthorisedError)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end
end

module AcademiesApiHelpers
  def mock_successful_api_calls(establishment:, trust:)
    fake_client = double(Api::AcademiesApi::Client,
      get_establishments: Api::AcademiesApi::Client::Result.new([establishment], nil),
      get_establishment: Api::AcademiesApi::Client::Result.new(establishment, nil),
      get_trusts: Api::AcademiesApi::Client::Result.new([trust], nil),
      get_trust: Api::AcademiesApi::Client::Result.new(trust, nil))

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)
  end

  def mock_all_academies_api_responses
    establishment = build(:academies_api_establishment)
    trust = build(:academies_api_trust)

    establishments = build_list(:academies_api_establishment, 3)
    trusts = build_list(:academies_api_trust, 3)

    fake_client = double(Api::AcademiesApi::Client,
      get_establishments: Api::AcademiesApi::Client::Result.new(establishments, nil),
      get_establishment: Api::AcademiesApi::Client::Result.new(establishment, nil),
      get_trusts: Api::AcademiesApi::Client::Result.new(trusts, nil),
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
    local_authority = build(:local_authority)

    fake_result = Api::AcademiesApi::Client::Result.new(establishment, nil)
    test_client = Api::AcademiesApi::Client.new

    allow(establishment).to receive(:local_authority).and_return(local_authority)
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

  def mock_trust_not_found(ukprn:)
    mock_client = Api::AcademiesApi::Client.new
    not_found_result = Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new(I18n.t("academies_api.get_trust.errors.not_found", ukprn: ukprn)))
    allow(mock_client).to receive(:get_trust).with(ukprn).and_return(not_found_result)
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
    allow(test_client).to receive(:get_establishment).with(urn).and_raise(Api::AcademiesApi::Client::UnauthorisedError)
    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end

  def mock_api_for_editing
    establishment = build(:academies_api_establishment)
    local_authority = build(:local_authority)
    allow(establishment).to receive(:local_authority).and_return(local_authority)

    mock_establishment = Api::AcademiesApi::Client::Result.new(establishment, nil)

    trust = build(:academies_api_trust, ukprn: 10059151)
    mock_before_incoming_trust = Api::AcademiesApi::Client::Result.new(trust, nil)

    trust = build(:academies_api_trust, ukprn: 10058882)
    mock_after_incoming_trust = Api::AcademiesApi::Client::Result.new(trust, nil)

    trust = build(:academies_api_trust, ukprn: 10059797)
    mock_before_outgoing_trust = Api::AcademiesApi::Client::Result.new(trust, nil)

    trust = build(:academies_api_trust, ukprn: 10064639)
    mock_after_outgoing_trust = Api::AcademiesApi::Client::Result.new(trust, nil)

    test_client = Api::AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(123456).and_return(mock_establishment)
    allow(test_client).to receive(:get_trust).with(10059151).and_return(mock_before_incoming_trust)
    allow(test_client).to receive(:get_trust).with(10058882).and_return(mock_after_incoming_trust)

    allow(test_client).to receive(:get_trust).with(10059797).and_return(mock_before_outgoing_trust)
    allow(test_client).to receive(:get_trust).with(10064639).and_return(mock_after_outgoing_trust)

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(test_client)
  end
end

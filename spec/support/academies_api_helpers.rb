module AcademiesApiHelpers
  def mock_successful_api_establishment_response(urn:, establishment: nil)
    establishment = build(:academies_api_establishment) if establishment.nil?

    fake_result = AcademiesApi::Client::Result.new(establishment, nil)
    test_client = AcademiesApi::Client.new

    allow(test_client).to receive(:get_establishment).with(urn).and_return(fake_result)
    allow(AcademiesApi::Client).to receive(:new).and_return(test_client)
  end
end

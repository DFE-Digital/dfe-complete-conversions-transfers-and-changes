module PersonsApiHelpers
  # Test Faraday connections
  #
  # responses are an array of
  #
  # - status code
  # - headers
  # - body
  #
  # Persons API docs:
  #
  # https://s184d01-tramsapicdnendpoint-personsapi-a3d9cpcwahc6dnh0.z01.azurefd.net/swagger/index.html

  def test_successful_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v1/constituencies/test/mp") do |_env|
          [200, nil, {
            firstName: "First",
            lastName: "Last",
            email: "lastf@parliament.gov.uk"
          }.to_json]
        end
      end
    end
  end

  def test_not_found_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v1/constituencies/test/mp") do |_env|
          [404, nil, nil]
        end
      end
    end
  end

  def test_error_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v1/constituencies/test/mp") do |_env|
          [400, nil, nil]
        end
      end
    end
  end

  def mock_successful_persons_api_client
    member = Api::Persons::MemberDetails.new(
      {firstName: "First", lastName: "Last", email: "lastf@parliament.gov.uk"}.with_indifferent_access
    )
    result = Api::Persons::Client::Result.new(member, nil)
    client = Api::Persons::Client.new(connection: test_successful_connection)

    allow(Api::Persons::Client).to receive(:new).and_return(client)
    allow(client).to receive(:member_for_constituency).and_return(result)

    client
  end

  def mock_failed_persons_api_client
    result = Api::Persons::Client::Result.new(nil, Api::Persons::Client::Error.new)
    client = Api::Persons::Client.new(connection: test_successful_connection)

    allow(Api::Persons::Client).to receive(:new).and_return(client)
    allow(client).to receive(:member_for_constituency).and_return(result)

    client
  end
end

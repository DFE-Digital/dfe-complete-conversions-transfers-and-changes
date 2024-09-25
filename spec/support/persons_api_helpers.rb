module PersonsApiHelpers
  # Test Faraday connections for Persons API
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

  def test_api_successful_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v1/constituencies/test/mp") do |_env|
          [200, nil, {
            firstName: "First",
            lastName: "Last",
            displayNameWithTitle: "The Right Honourable Firstname Lastname",
            email: "lastf@parliament.gov.uk"
          }.to_json]
        end
      end
    end
  end

  def test_api_not_found_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v1/constituencies/test/mp") do |_env|
          [404, nil, nil]
        end
      end
    end
  end

  def test_api_error_connection
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
      {firstName: "First", lastName: "Last", displayNameWithTitle: "The Right Honourable Firstname Lastname", email: "lastf@parliament.gov.uk"}.with_indifferent_access
    )
    result = Api::Persons::Client::Result.new(member, nil)
    client = Api::Persons::Client.new

    allow(Api::Persons::Client).to receive(:new).and_return(client)
    allow(client).to receive(:member_for_constituency).and_return(result)
    allow(client).to receive(:token).and_return("a-fake-token")

    client
  end

  def mock_failed_persons_api_client
    result = Api::Persons::Client::Result.new(nil, Api::Persons::Client::Error.new)
    client = Api::Persons::Client.new

    allow(Api::Persons::Client).to receive(:new).and_return(client)
    allow(client).to receive(:member_for_constituency).and_return(result)

    client
  end

  # Test Faraday connections for Azure Microsoft identity platform
  #
  # Docs:
  #
  # https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow#get-a-token

  def test_auth_successful_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/oauth2/v2.0/token") do |_env|
          [200, nil, {
            access_token: "fake-access-token",
            expires_in: 3599
          }.to_json]
        end
      end
    end
  end

  def test_auth_error_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/oauth2/v2.0/token") do |_env|
          [401, nil, nil]
        end
      end
    end
  end
end

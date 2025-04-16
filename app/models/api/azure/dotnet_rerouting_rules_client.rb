class Api::Azure::DotnetReroutingRulesClient
  def initialize
    @connection = default_connection
    @auth_connection = default_auth_connection
    @token = set_token
  end

  def get
    @connection.headers["Authorization"] = "Bearer #{@token}"
    response = @connection.get(resource_path)
    raise Error("Not successful", response) unless response.status == 200

    JSON.parse(response.body)
  end

  def experimental_get_with_managed_identity
    options = {
      tenant_id: ENV.fetch("AZURE_FRONT_DOOR_TENANT_ID"),
      client_id: ENV.fetch("AZURE_FRONT_DOOR_CLIENT_ID"),
      client_secret: ENV.fetch("AZURE_FRONT_DOOR_CLIENT_SECRET"),
      subscription_id: ENV.fetch("AZURE_FRONT_DOOR_SUBSCRIPTION_ID")
    }

    provider = MsRestAzure::MSITokenProvider.new(50342, settings, {client_id: options[:client_id]})
    credentials = MsRest::TokenCredentials.new(provider)
    client = Azure::Resources::Profiles::Latest::Mgmt::Client.new(options.merge(credentials: credentials))

    request = MsRest::HttpOperationRequest.new(
      "https://management.azure.com",
      resource_path,
      "get"
    )

    client.get_async_common(request)
  end

  private def resource_path
    [
      "/subscriptions/#{ENV.fetch("AZURE_FRONT_DOOR_SUBSCRIPTION_ID")}",
      "resourceGroups/#{ENV.fetch("AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME")}",
      "providers/Microsoft.Cdn",
      "profiles/#{ENV.fetch("AZURE_FRONT_DOOR_PROFILE_NAME")}",
      "ruleSets/#{ENV.fetch("AZURE_FRONT_DOOR_RULE_SET_NAME")}",
      "rules/rerouteorigin?api-version=2023-05-01"
    ].join("/")
  end

  private def default_connection
    Faraday.new(
      url: "https://management.azure.com",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": Rails.application.config.dfe_user_agent
      }
    )
  end

  private def set_token
    auth_response = @auth_connection.post(
      "oauth2/v2.0/token",
      {
        client_id: ENV.fetch("AZURE_INFRA_CLIENT_ID"),
        client_secret: ENV.fetch("AZURE_INFRA_CLIENT_SECRET"),
        grant_type: "client_credentials",
        scope: "https://management.azure.com/.default"
      }
    )

    if auth_response.status.eql?(200)
      token_response = JSON.parse(auth_response.body)
    else
      raise AuthError.new("Error from Azure authentication request: #{auth_response.status} #{auth_response.reason_phrase}")
    end
    token_response["access_token"]
  end

  private def default_auth_connection
    auth_host_uri = "https://login.microsoftonline.com/#{ENV.fetch("AZURE_INFRA_TENANT_ID")}/"

    Faraday.new(url: auth_host_uri)
  end
end

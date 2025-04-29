class Api::Azure::DotnetReroutingRulesClient
  class Error < StandardError; end

  class AuthError < StandardError; end

  def initialize
    @connection = management_connection
    @token = managed_identity_token
  end

  def get_rules
    @connection.headers["Authorization"] = "Bearer #{@token}"
    response = @connection.get(resource_path)
    raise Error.new("Error fetching re-routing rules: #{response}") unless response.status == 200

    JSON.parse(response.body)
  end

  private def resource_path
    [
      "/subscriptions/#{ENV.fetch("AZURE_SUBSCRIPTION_ID")}",
      "resourceGroups/#{ENV.fetch("AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME")}",
      "providers/Microsoft.Cdn",
      "profiles/#{ENV.fetch("AZURE_FRONT_DOOR_PROFILE_NAME")}",
      "ruleSets/#{ENV.fetch("AZURE_FRONT_DOOR_RULE_SET_NAME")}",
      "rules/rerouteorigin?api-version=2023-05-01"
    ].join("/")
  end

  private def management_connection
    Faraday.new(
      url: "https://management.azure.com",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": Rails.application.config.dfe_user_agent
      }
    )
  end

  private def managed_identity_token
    auth_response = Faraday.new(
      url: ENV.fetch("IDENTITY_ENDPOINT"),
      headers: {
        "Content-Type": "application/json",
        "X-IDENTITY-HEADER": ENV.fetch("IDENTITY_HEADER")
      },
      params: {
        "api-version": "2019-08-01",
        resource: "https://management.azure.com/",
        client_id: ENV.fetch("AZURE_CLIENT_ID")
      }
    ).get("")

    if auth_response.status.eql?(200)
      token_response = JSON.parse(auth_response.body)
    else
      raise AuthError.new("Error obtaining managed identity auth: #{auth_response.status} #{auth_response.reason_phrase}")
    end

    token_response.fetch("access_token")
  end
end

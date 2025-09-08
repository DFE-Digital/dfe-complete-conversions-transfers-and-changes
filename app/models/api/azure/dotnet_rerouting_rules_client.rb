require "uri"
require "faraday"
require "faraday/retry"

class Api::Azure::DotnetReroutingRulesClient
  class Error < StandardError; end
  class AuthError < StandardError; end
  class TokenExpiredError < AuthError; end

  def initialize
    @connection = management_connection
    @token = nil
    @token_expires_at = nil
  end

  def get_rules
    ensure_valid_token
    @connection.headers["Authorization"] = "Bearer #{@token}"
    
    response = @connection.get(resource_path)
    
    case response.status
    when 200
      JSON.parse(response.body)
    when 401
      # Token might be expired, try to refresh
      refresh_token
      @connection.headers["Authorization"] = "Bearer #{@token}"
      response = @connection.get(resource_path)
      
      if response.status == 200
        JSON.parse(response.body)
      else
        raise AuthError.new("Authentication failed after token refresh: status=#{response.status}")
      end
    else
      body_preview = begin
        response.body.to_s[0, 2000]
      rescue
        "(no body)"
      end
      raise Error.new(
        "Error fetching re-routing rules: status=#{response.status} url=#{@connection.url_prefix}#{resource_path} body=#{body_preview}"
      )
    end
  end

  private def resource_path
    [
      "/subscriptions/#{ENV.fetch("AZURE_SUBSCRIPTION_ID")}",
      "resourceGroups/#{ENV.fetch("AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME")}",
      "providers/Microsoft.Cdn",
      "profiles/#{ENV.fetch("AZURE_FRONT_DOOR_PROFILE_NAME")}",
      "ruleSets/#{ENV.fetch("AZURE_FRONT_DOOR_RULE_SET_NAME")}",
      "rules?api-version=2024-02-01"
    ].join("/")
  end

  private def management_connection
    Faraday.new(
      url: "https://management.azure.com",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": Rails.application.config.dfe_user_agent
      }
    ) do |conn|
      conn.request :retry, {
        max: 3,
        interval: 0.5,
        interval_randomness: 0.5,
        backoff_factor: 2,
        retry_statuses: [429, 500, 502, 503, 504]
      }
    end
  end

  private def ensure_valid_token
    if @token.nil? || token_expired?
      refresh_token
    end
  end

  private def token_expired?
    @token_expires_at.nil? || @token_expires_at <= Time.now + 300 # 5 minutes buffer
  end

  private def refresh_token
    @token = if client_credentials_available?
               client_credentials_token
             else
               managed_identity_token
             end
    @token_expires_at = Time.now + 3600 # Assume 1 hour expiry
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
      body_preview = begin
        auth_response.body.to_s[0, 1000]
      rescue
        "(no body)"
      end
      raise AuthError.new("Error obtaining managed identity auth: status=#{auth_response.status} body=#{body_preview}")
    end

    token_response.fetch("access_token")
  end

  private def client_credentials_available?
    ENV["AZURE_TENANT_ID"].present? &&
      ENV["AZURE_APPLICATION_CLIENT_ID"].present? &&
      ENV["AZURE_APPLICATION_CLIENT_SECRET"].present?
  end

  private def client_credentials_token
    token_url = "https://login.microsoftonline.com/#{ENV.fetch("AZURE_TENANT_ID")}/oauth2/v2.0/token"

    response = Faraday.new(
      headers: { "Content-Type": "application/x-www-form-urlencoded" }
    ).post(token_url) do |req|
      req.body = URI.encode_www_form(
        client_id: ENV.fetch("AZURE_APPLICATION_CLIENT_ID"),
        client_secret: ENV.fetch("AZURE_APPLICATION_CLIENT_SECRET"),
        scope: "https://management.azure.com/.default",
        grant_type: "client_credentials"
      )
    end

    unless response.status == 200
      body_preview = begin
        response.body.to_s[0, 1000]
      rescue
        "(no body)"
      end
      raise AuthError.new("Error obtaining client credentials auth: status=#{response.status} body=#{body_preview}")
    end

    JSON.parse(response.body).fetch("access_token")
  end
end

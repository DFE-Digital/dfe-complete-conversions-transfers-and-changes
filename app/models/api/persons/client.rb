class Api::Persons::Client
  TOKEN_CACHE_KEY = "persons_api_token".freeze
  TOKEN_CACHE_EXPIRY_BUFFER = 60

  class NotFoundError < StandardError; end

  class Error < StandardError; end

  class AuthError < StandardError; end

  class Result
    attr_reader :object, :error

    def initialize(object, error)
      @object = object
      @error = error
    end
  end

  def initialize(api_connection: nil, auth_connection: nil)
    @api_connection = api_connection || default_api_connection
    @auth_connection = auth_connection || default_auth_connection
  end

  def token
    token = Rails.cache.read(TOKEN_CACHE_KEY)
    set_token if token.nil?

    Rails.cache.read(TOKEN_CACHE_KEY)
  end

  def member_for_constituency(constituency_name)
    encoded_constituency_name = URI.encode_uri_component(constituency_name)

    @api_connection.headers["Authorization"] = "Bearer #{token}"

    response = @api_connection.get("/v1/constituencies/#{encoded_constituency_name}/mp")

    case response.status
    when 200
      member = Api::Persons::MemberDetails.new(JSON.parse(response.body))
      Result.new(member, nil)
    when 404
      Result.new(nil, NotFoundError.new("#{response.status}: #{response.reason_phrase}"))
    else
      Result.new(nil, Error.new("#{response.status}: #{response.reason_phrase}"))
    end
  end

  private def set_token
    # Fetch the OAuth token with client credentials grant type, see:
    # https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-client-creds-grant-flow#get-a-token
    #
    # The path must be relative as the directory id forms the second component of the url prefix.
    auth_response = @auth_connection.post(
      "oauth2/v2.0/token",
      {
        client_id: ENV["PERSONS_API_AUTH_ID"],
        client_secret: ENV["PERSONS_API_AUTH_SECRET"],
        grant_type: "client_credentials",
        scope: ENV["PERSONS_API_AUTH_SCOPE"]
      }
    )

    if auth_response.status.eql?(200)
      token_response = JSON.parse(auth_response.body)

      Rails.cache.write(
        TOKEN_CACHE_KEY, token_response["access_token"],
        expires_in: token_response["expires_in"] - TOKEN_CACHE_EXPIRY_BUFFER
      )
    else
      raise AuthError.new("Error from Persons API authentication request: #{auth_response.status} #{auth_response.reason_phrase}")
    end
  end

  private def default_auth_connection
    auth_host_uri = URI(ENV["PERSONS_API_AUTH_HOST"] + "/" + ENV["PERSONS_API_AUTH_DIRECTORY_ID"] + "/")

    Faraday.new(url: auth_host_uri)
  end

  private def default_api_connection
    Faraday.new(
      url: ENV["PERSONS_API_HOST"],
      headers: {
        "Content-Type": "application/json"
      }
    )
  end
end

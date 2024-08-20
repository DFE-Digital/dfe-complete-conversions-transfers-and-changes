class Api::Persons::Client
  class NotFoundError < StandardError; end

  class Error < StandardError; end

  class Result
    attr_reader :object, :error

    def initialize(object, error)
      @object = object
      @error = error
    end
  end

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def member_for_constituency(constituency_name)
    encoded_constituency_name = URI.encode_uri_component(constituency_name)
    response = @connection.get("/v1/constituencies/#{encoded_constituency_name}/mp")

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

  private def default_connection
    Faraday.new(
      url: ENV["PERSONS_API_HOST"],
      headers: {
        "Content-Type": "application/json",
        ApiKey: ENV["PERSONS_API_KEY"]
      }
    )
  end
end

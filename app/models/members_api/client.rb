class MembersApi::Client
  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  private def default_connection
    Faraday.new(
      url: ENV["MEMBERS_API_HOST"],
      request: {
        params_encoder: Faraday::FlatParamsEncoder
      },
      headers: {
        "Content-Type": "application/json"
      }
    )
  end
end

class AcademiesApi::Client
  ACADEMIES_API_TIMEOUT = 0.6

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  private def default_connection
    Faraday.new(
      url: ENV["ACADEMIES_API_HOST"],
      request: {
        timeout: ACADEMIES_API_TIMEOUT
      },
      headers: {
        "Content-Type": "application/json",
        ApiKey: ENV["ACADEMIES_API_KEY"]
      }
    )
  end
end

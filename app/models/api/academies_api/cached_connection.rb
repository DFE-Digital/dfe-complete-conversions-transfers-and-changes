class Api::AcademiesApi::CachedConnection
  def initialize(api_connection:)
    @api_connection = api_connection
  end

  def fetch(path:, params: nil)
    return @api_connection.get(path, params) if params

    @api_connection.get(path)
  end
end

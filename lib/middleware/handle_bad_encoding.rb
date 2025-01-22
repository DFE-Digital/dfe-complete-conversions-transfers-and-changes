class HandleBadEncoding
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      Rack::Utils.parse_nested_query(env["REQUEST_URI"].to_s)
    rescue Rack::QueryParser::InvalidParameterError
      env["PATH_INFO"] = "/"
    end

    @app.call(env)
  end
end

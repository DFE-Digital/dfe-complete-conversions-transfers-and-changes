class HandleBadQuery
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      Rack::Utils.parse_nested_query(env["QUERY_STRING"].to_s)
    rescue Rack::QueryParser::ParameterTypeError
      env["QUERY_STRING"] = ""
    end

    @app.call(env)
  end
end

class AcademiesApi::Client
  ACADEMIES_API_TIMEOUT = 0.6

  class Error < StandardError; end

  class NotFoundError < StandardError; end

  class MultipleResultsError < StandardError; end

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def get_establishment(urn)
    begin
      response = @connection.get("/establishment/urn/#{urn}")
    rescue Faraday::Error => error
      raise Error.new(error)
    end

    case response.status
    when 200
      Result.new(AcademiesApi::Establishment.new.from_json(response.body), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_establishment.errors.not_found", urn: urn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishment.errors.other", urn: urn)))
    end
  end

  def get_conversion_project(urn)
    begin
      response = @connection.get("/v2/conversion-projects", {urn: urn})
    rescue Faraday::Error => error
      raise Error.new(error)
    end

    case response.status
    when 200
      data = JSON.parse(response.body)

      record_count = data["paging"]["recordCount"]

      if record_count == 0
        Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_conversion_project.errors.not_found", urn: urn)))
      elsif record_count > 1
        Result.new(nil, MultipleResultsError.new(I18n.t("academies_api.get_conversion_project.errors.multiple_results", urn: urn, record_count: record_count)))
      else
        Result.new(AcademiesApi::ConversionProject.new.from_hash(data["data"][0]), nil)
      end
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_conversion_project.errors.other", urn: urn)))
    end
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

  class Result
    attr_reader :object, :error

    def initialize(object, error)
      @object = object
      @error = error
    end
  end
end

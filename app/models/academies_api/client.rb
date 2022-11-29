class AcademiesApi::Client
  ACADEMIES_API_TIMEOUT = ENV.fetch("ACADEMIES_API_TIMEOUT", 0.6).to_f

  class Error < StandardError; end

  class NotFoundError < StandardError; end

  class MultipleResultsError < StandardError; end

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def get_establishment(urn)
    begin
      response = @connection.get("/establishments/bulk", {urn:})
    rescue Faraday::Error => error
      raise Error.new(error)
    end

    case response.status
    when 200
      Result.new(AcademiesApi::Establishment.new.from_hash(JSON.parse(response.body)[0]), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_establishment.errors.not_found", urn: urn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishment.errors.other", urn: urn)))
    end
  end

  def get_trust(ukprn)
    begin
      response = @connection.get("/v2/trusts/bulk", {ukprn:, establishments: false})
    rescue Faraday::Error => error
      raise Error.new(error)
    end

    case response.status
    when 200
      Result.new(AcademiesApi::Trust.new.from_hash(JSON.parse(response.body)["data"][0]), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_trust.errors.not_found", ukprn: ukprn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_trust.errors.other", ukprn: ukprn)))
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

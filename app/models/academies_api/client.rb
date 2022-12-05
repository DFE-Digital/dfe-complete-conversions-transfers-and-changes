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
    response = fetch_establishments([urn])

    case response.status
    when 200
      Result.new(AcademiesApi::Establishment.new.from_hash(single_establishment_from_bulk(response)), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_establishment.errors.not_found", urn: urn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishment.errors.other", urn: urn)))
    end
  end

  def get_establishments(urns)
    response = fetch_establishments(urns)

    case response.status
    when 200
      establishments = JSON.parse(response.body).map do |establishment|
        AcademiesApi::Establishment.new.from_hash(establishment)
      end
      Result.new(establishments, nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_establishments.errors.not_found", urns:)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishments.errors.other", urns:)))
    end
  end

  def get_trust(ukprn)
    begin
      response = @connection.get("/v2/trust/#{ukprn}")
    rescue Faraday::Error => error
      raise Error.new(error)
    end

    case response.status
    when 200
      Result.new(AcademiesApi::Trust.new.from_json(response.body), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_trust.errors.not_found", ukprn: ukprn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_trust.errors.other", ukprn: ukprn)))
    end
  end

  private def fetch_establishments(urns)
    @connection.get("/establishments/bulk", {urn: urns})
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def single_establishment_from_bulk(response)
    JSON.parse(response.body)[0]
  end

  private def default_connection
    Faraday.new(
      url: ENV["ACADEMIES_API_HOST"],
      request: {
        timeout: ACADEMIES_API_TIMEOUT,
        params_encoder: Faraday::FlatParamsEncoder
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

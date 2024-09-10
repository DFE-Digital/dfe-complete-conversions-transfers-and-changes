class Api::AcademiesApi::Client
  ACADEMIES_API_TIMEOUT = ENV.fetch("ACADEMIES_API_TIMEOUT", 0.6).to_f

  class Error < StandardError; end

  class NotFoundError < StandardError; end

  class MultipleResultsError < StandardError; end

  class UnauthorisedError < StandardError; end

  attr_reader :connection

  def initialize(connection: nil)
    @connection = connection || default_connection
  end

  def get_establishment(urn)
    response = fetch_establishments([urn])

    case response.status
    when 200
      Result.new(Api::AcademiesApi::Establishment.new.from_hash(single_establishment_from_bulk(response)), nil)
    when 401
      raise Api::AcademiesApi::Client::UnauthorisedError.new("Problems connecting to the Academies API")
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
        Api::AcademiesApi::Establishment.new.from_hash(establishment)
      end
      Result.new(establishments, nil)
    when 401
      raise Api::AcademiesApi::Client::UnauthorisedError.new("Problems connecting to the Academies API")
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_establishments.errors.not_found", urns:)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishments.errors.other", urns:)))
    end
  end

  def get_trust(ukprn)
    response = fetch_trusts([ukprn])

    case response.status
    when 200
      Result.new(Api::AcademiesApi::Trust.new.from_hash(single_trust_from_bulk(response)), nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_trust.errors.not_found", ukprn: ukprn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_trust.errors.other", ukprn: ukprn)))
    end
  end

  def get_trusts(ukprns)
    response = fetch_trusts(ukprns)

    case response.status
    when 200
      trusts = JSON.parse(response.body).map do |trust|
        Api::AcademiesApi::Trust.new.from_hash(trust)
      end
      Result.new(trusts, nil)
    when 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_trusts.errors.not_found", ukprns:)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_trusts.errors.other", ukprns:)))
    end
  end

  private def fetch_establishments(urns)
    Rails.logger.info("Academies API: fetching establishments: #{urns}")

    @connection.get("/v4/establishments/bulk", {request: urns})
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def fetch_trusts(ukprns)
    Rails.logger.info("Academies API: fetching trusts: #{ukprns}")

    @connection.get("/v4/trusts/bulk", {ukprns: ukprns})
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def single_establishment_from_bulk(response)
    JSON.parse(response.body)[0]
  end

  private def single_trust_from_bulk(response)
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
        ApiKey: ENV["ACADEMIES_API_KEY"],
        "User-Agent": "Complete/1.0"
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

class Api::AcademiesApi::Client
  ACADEMIES_API_TIMEOUT = ENV.fetch("ACADEMIES_API_TIMEOUT", 0.6).to_f

  class Error < StandardError; end

  class NotFoundError < StandardError; end

  class UnauthorisedError < StandardError; end

  attr_reader :connection

  def initialize(connection: nil, cached_connection: nil)
    @connection = connection || default_connection
    @cached_connection = cached_connection || Api::AcademiesApi::CachedConnection.new(
      api_connection: @connection
    )
  end

  def get_establishment(urn)
    response = fetch_establishment(urn)

    case response.status
    when 200
      Result.new(Api::AcademiesApi::Establishment.new.from_hash(JSON.parse(response.body)), nil)
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
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishments.errors.other", urns:)))
    end
  end

  def get_trust(ukprn)
    response = fetch_trust(ukprn)

    case response.status
    when 200
      Result.new(Api::AcademiesApi::Trust.new.from_hash(JSON.parse(response.body)), nil)
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
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_trusts.errors.other", ukprns:)))
    end
  end

  private def fetch_establishment(urn)
    Rails.logger.info("Academies API: fetching establishment: #{urn}")
    @cached_connection.fetch(path: "/v4/establishment/urn/#{urn}")
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def fetch_establishments(urns)
    Rails.logger.info("Academies API: fetching establishments: #{urns}")

    @cached_connection.fetch(path: "/v4/establishments/bulk", params: {request: urns})
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def fetch_trust(ukprn)
    Rails.logger.info("Academies API: fetching trust: #{ukprn}")

    @cached_connection.fetch(path: "/v4/trust/#{ukprn}")
  rescue Faraday::Error => error
    raise Error.new(error)
  end

  private def fetch_trusts(ukprns)
    Rails.logger.info("Academies API: fetching trusts: #{ukprns}")

    @cached_connection.fetch(path: "/v4/trusts/bulk", params: {ukprns: ukprns})
  rescue Faraday::Error => error
    raise Error.new(error)
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
        "User-Agent": Rails.application.config.dfe_user_agent
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

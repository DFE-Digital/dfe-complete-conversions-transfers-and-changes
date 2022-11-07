class AcademiesApi::Client
  class Error < StandardError; end

  class NotFoundError < StandardError; end

  class MultipleResultsError < StandardError; end

  def initialize(immediate_execution: false)
    @hydra = Typhoeus::Hydra.new
    @immediate_execution = immediate_execution
  end

  def self.with_immediate_execution
    new(immediate_execution: true)
  end

  def get_establishment(urn, &callback)
    request = build_request(path: "/establishment/urn/#{urn}")
    request.on_complete do |response|
      response = handle_establishment_response(response, urn)
      callback.call(response)
    end

    @hydra.queue(request)
    execute if @immediate_execution
  end

  def get_trust(ukprn, &callback)
    request = build_request(path: "/v2/trust/#{ukprn}")
    request.on_complete do |response|
      response = handle_trust_response(response, ukprn)
      callback.call(response)
    end

    @hydra.queue request
    execute if @immediate_execution
  end

  def execute
    @hydra.run
  end

  private def handle_establishment_response(response, urn)
    if response.success?
      Result.new(AcademiesApi::Establishment.new.from_json(response.body), nil)
    elsif response.code == 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_establishment.errors.not_found", urn: urn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_establishment.errors.other", urn: urn)))
    end
  end

  private def handle_trust_response(response, ukprn)
    if response.success?
      Result.new(AcademiesApi::Trust.new.from_json(response.body), nil)
    elsif response.code == 404
      Result.new(nil, NotFoundError.new(I18n.t("academies_api.get_trust.errors.not_found", ukprn: ukprn)))
    else
      Result.new(nil, Error.new(I18n.t("academies_api.get_trust.errors.other", ukprn: ukprn)))
    end
  end

  private def build_request(path:)
    Typhoeus::Request.new(
      "#{ENV["ACADEMIES_API_HOST"]}#{path}",
      headers: default_headers
    )
  end

  private def default_headers
    {
      "Content-Type": "application/json",
      ApiKey: ENV["ACADEMIES_API_KEY"]
    }
  end

  class Result
    attr_reader :object, :error

    def initialize(object, error)
      @object = object
      @error = error
    end
  end
end

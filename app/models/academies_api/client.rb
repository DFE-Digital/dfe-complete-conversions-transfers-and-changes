require 'async'
require 'async/http/internet'


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
    Async do
      internet = Async::HTTP::Internet.new

      headers = {
        "Content-Type": "application/json",
        ApiKey: ENV["ACADEMIES_API_KEY"]
      }

      response = internet.get("#{ENV["ACADEMIES_API_HOST"]}/establishment/urn/#{urn}", headers)

      Result.new(AcademiesApi::Establishment.new.from_json(response.read), nil)
    ensure
      internet.close
    end
  end

  def get_trust(ukprn)
    Async do
      internet = Async::HTTP::Internet.new

      headers = {
        "Content-Type": "application/json",
        ApiKey: ENV["ACADEMIES_API_KEY"]
      }

      response = internet.get("#{ENV["ACADEMIES_API_HOST"]}/v2/trust/#{ukprn}", headers)

      Result.new(AcademiesApi::Establishment.new.from_json(response.read), nil)
    ensure
      internet.close
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

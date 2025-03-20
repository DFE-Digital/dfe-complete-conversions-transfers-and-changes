require "rails_helper"

RSpec.describe Api::AcademiesApi::CachedConnection do
  around do |example|
    ClimateControl.modify ACADEMIES_API_CACHE: "active" do
      example.run
    end
  end

  let(:faraday_connection) { double("faraday_connection", get: double) }
  let(:cache_keyer) { class_double(Api::AcademiesApi::CacheKeyer) }
  let(:cache) { instance_double(ActiveSupport::Cache::RedisCacheStore) }
  let(:logger) { double("logger", info: true) }

  let(:cached_connection) do
    Api::AcademiesApi::CachedConnection.new(
      api_connection: faraday_connection,
      cache_keyer: cache_keyer,
      cache: cache,
      logger: logger
    )
  end

  describe "#fetch" do
    before do
      allow(cache_keyer).to receive(:for_path).and_return("CACHE_KEY")
      allow(cache).to receive(:read).and_return(nil)
      allow(cache).to receive(:write).and_return("OK")
    end

    it "obtains the cache key for the given path/params from the CacheKeyer" do
      cached_connection.fetch(path: "/v4/establishment/urn/123456", params: {request: [123456, 333333]})

      expect(cache_keyer).to have_received(:for_path).with(
        path: "/v4/establishment/urn/123456",
        params: {request: [123456, 333333]}
      )
    end

    it "attempts to retrieve a cached value for the given key" do
      cached_connection.fetch(path: "/v4/establishment/urn/123456")

      expect(cache).to have_received(:read).with("CACHE_KEY")
    end

    context "when a value can be retrieved from the cache" do
      before do
        allow(cache).to receive(:read).and_return({urn: 123456})
      end

      it "returns that cached value" do
        expect(cached_connection.fetch(path: "/v4/establishment/urn/123456")).to eq({urn: 123456})
      end

      it "logs the 'hit'" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456", params: {request: [123456, 333333]})

        expect(logger).to have_received(:info).with(
          "Hit for CACHE_KEY [path: /v4/establishment/urn/123456 params: {request: [123456, 333333]}]"
        )
      end

      it "does not make a call to the Academies API" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456")

        expect(faraday_connection).not_to have_received(:get)
      end
    end

    context "when a value can't be retrieved from the cache" do
      before do
        allow(cache).to receive(:read).and_return(nil)
        allow(faraday_connection).to receive(:get).and_return({urn: 666666})
      end

      it "makes a call to the Academies API" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456")

        expect(faraday_connection).to have_received(:get).with("/v4/establishment/urn/123456")
      end

      it "logs the 'miss'" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456", params: {request: [123456, 333333]})

        expect(logger).to have_received(:info).with(
          "Miss for CACHE_KEY [path: /v4/establishment/urn/123456 params: {request: [123456, 333333]}]"
        )
      end

      it "stores the value retrieved from the Academies API using the key provided by CacheKeyer" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456")

        expect(cache).to have_received(:write).with(
          "CACHE_KEY",
          {urn: 666666},
          {expires_in: 24.hours}
        )
      end

      it "returns the value retrieved from the Academies API" do
        expect(cached_connection.fetch(path: "/v4/establishment/urn/123456")).to eq({urn: 666666})
      end
    end

    it "makes a get request to the Faraday HTTP connection (caching to follow)" do
      cached_connection.fetch(path: "/v4/establishment/urn/123456")

      expect(faraday_connection).to have_received(:get).with("/v4/establishment/urn/123456")
    end

    it "passes on additional url params, needed for bulk endpoints" do
      cached_connection.fetch(path: "/v4/establishments/bulk", params: {request: [123456, 333333]})

      expect(faraday_connection).to have_received(:get).with("/v4/establishments/bulk", {request: [123456, 333333]})
    end

    context "when caching is disabled" do
      around do |example|
        ClimateControl.modify ACADEMIES_API_CACHE: "disabled" do
          example.run
        end
      end

      before do
        allow(faraday_connection).to receive(:get).and_return({urn: 666666})
      end

      it "does NOT obtain the cache key from the CacheKeyer" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456", params: {request: [123456, 333333]})

        expect(cache_keyer).not_to have_received(:for_path)
      end

      it "does NOT attempt to retrieve a cached value" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456")

        expect(cache).not_to have_received(:read)
      end

      it "does NOT log anything" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456", params: {request: [123456, 333333]})

        expect(logger).not_to have_received(:info)
      end

      it "makes a get request to the Faraday HTTP connection (caching to follow)" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456")

        expect(faraday_connection).to have_received(:get).with("/v4/establishment/urn/123456")
      end

      it "returns the value retrieved from the Academies API" do
        expect(cached_connection.fetch(path: "/v4/establishment/urn/123456")).to eq({urn: 666666})
      end
    end

    context "when the env var for toggling the cache is missing" do
      before do
        ENV.delete("ACADEMIES_API_CACHE")
        allow(faraday_connection).to receive(:get).and_return({urn: 666666})
      end

      it "does not cause an error" do
        expect { cached_connection.fetch(path: "/v4/establishment/urn/123456") }.not_to raise_error
      end

      it "makes a get request to the Faraday HTTP connection (caching to follow)" do
        cached_connection.fetch(path: "/v4/establishment/urn/123456")

        expect(faraday_connection).to have_received(:get).with("/v4/establishment/urn/123456")
      end

      it "returns the value retrieved from the Academies API" do
        expect(cached_connection.fetch(path: "/v4/establishment/urn/123456")).to eq({urn: 666666})
      end
    end
  end
end

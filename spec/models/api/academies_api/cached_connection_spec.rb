require "rails_helper"

RSpec.describe Api::AcademiesApi::CachedConnection do
  let(:faraday_connection) { double("faraday_connection", get: double) }

  let(:cached_connection) { Api::AcademiesApi::CachedConnection.new(api_connection: faraday_connection) }

  describe "#fetch" do
    it "makes a get request to the Faraday HTTP connection (caching to follow)" do
      cached_connection.fetch(url: "/v4/establishment/urn/123456")

      expect(faraday_connection).to have_received(:get).with("/v4/establishment/urn/123456")
    end

    it "passes on additional url params, needed for bulk endpoints" do
      cached_connection.fetch(url: "/v4/establishments/bulk", params: {request: [123456, 333333]})

      expect(faraday_connection).to have_received(:get).with("/v4/establishments/bulk", {request: [123456, 333333]})
    end
  end
end

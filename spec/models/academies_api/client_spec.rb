require "rails_helper"

RSpec.describe AcademiesApi::Client do
  it "uses the environment variables to build the connection" do
    ClimateControl.modify(
      ACADEMIES_API_HOST: "https://test.academies.api",
      ACADEMIES_API_KEY: "api-key"
    ) do
      client_connection = described_class.new.connection

      expect(client_connection.scheme).to eql "https"
      expect(client_connection.host).to eql "test.academies.api"
      expect(client_connection.headers["ApiKey"]).to eql "api-key"
      expect(client_connection.options[:timeout]).to eql AcademiesApi::Client::ACADEMIES_API_TIMEOUT
    end
  end
end

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

  describe "#get_establishment" do
    let(:client) { described_class.new(connection: fake_successful_establishment_connection(12345678, fake_response)) }

    context "when the establishment can be found" do
      let(:fake_response) { [200, nil, {establishmentName: "Establishment Name"}.to_json] }

      it "returns a Result with the establishment and no error" do
        result = client.get_establishment(12345678)

        expect(result.object.name).to eql("Establishment Name")
        expect(result.error).to be_nil
      end
    end

    context "when the establishment cannot be found" do
      let(:fake_response) { [404, nil, nil] }

      it "returns a Result with a NotFoundError and no establishment" do
        the_result = client.get_establishment(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::NotFoundError)
      end
    end

    context "when there is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error and no establishment" do
        the_result = client.get_establishment(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::Error)
      end
    end

    context "when the connection fails" do
      it "raises an Error" do
        client = described_class.new(connection: fake_failed_establishment_connection(12345678))

        expect { client.get_establishment(12345678) }.to raise_error(AcademiesApi::Client::Error)
      end
    end
  end

  def fake_successful_establishment_connection(urn, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/establishment/urn/#{urn}") do |env|
          response
        end
      end
    end
  end

  def fake_failed_establishment_connection(urn)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/establishment/urn/#{urn}") do |env|
          raise Faraday::Error
        end
      end
    end
  end

  describe "#get_conversion_project" do
    let(:client) { described_class.new(connection: fake_successful_conversion_project_connection(12345678, fake_response)) }

    context "when the project can be found" do
      let(:fake_response) {
        [200, nil, {data: [{nameOfTrust: "THE RETICULATED SPLINES TRUST"}], paging: {
          page: 1,
          recordCount: 1,
          nextPageUrl: nil
        }}.to_json]
      }

      it "returns a Result with the project and no error" do
        result = client.get_conversion_project(12345678)

        expect(result.object.name_of_trust).to eql("THE RETICULATED SPLINES TRUST")
        expect(result.error).to be_nil
      end
    end

    context "when the project cannot be found" do
      let(:fake_response) {
        [200, nil, {data: [], paging: {
          page: 1,
          recordCount: 0,
          nextPageUrl: nil
        }}.to_json]
      }

      it "returns a Result with a NotFoundError and no establishment" do
        the_result = client.get_conversion_project(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::NotFoundError)
      end
    end

    context "when there are multiple matching projects" do
      let(:fake_response) {
        [200, nil, {data: [{nameOfTrust: "THE RETICULATED SPLINES TRUST"}, {nameOfTrust: "THE TRUST OF RETICULATES SPLINES"}], paging: {
          page: 1,
          recordCount: 2,
          nextPageUrl: nil
        }}.to_json]
      }

      it "returns a Result with a MultipleResultsError and no project" do
        the_result = client.get_conversion_project(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::MultipleResultsError)
      end
    end

    context "when there is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error and no conversion project" do
        the_result = client.get_conversion_project(12345678)

        expect(the_result.object).to be_nil
        expect(the_result.error).to be_a(AcademiesApi::Client::Error)
      end
    end

    context "when the connection fails" do
      it "raises an Error" do
        client = described_class.new(connection: fake_failed_conversion_project_connection(12345678))

        expect { client.get_conversion_project(12345678) }.to raise_error(AcademiesApi::Client::Error)
      end
    end
  end

  def fake_successful_conversion_project_connection(urn, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v2/conversion-projects?urn=#{urn}") do |env|
          response
        end
      end
    end
  end

  def fake_failed_conversion_project_connection(urn)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v2/conversion-projects?urn=#{urn}") do |env|
          raise Faraday::Error
        end
      end
    end
  end

  def fake_successful_trust_connection(ukprn, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v2/trust/#{ukprn}") do |env|
          response
        end
      end
    end
  end

  def fake_failed_trust_connection(ukprn)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/v2/trust/#{ukprn}") do |env|
          raise Faraday::Error
        end
      end
    end
  end
end

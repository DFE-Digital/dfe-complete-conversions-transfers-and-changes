require "rails_helper"

RSpec.describe Api::Persons::Client do
  include PersonsApiHelpers

  it "uses the environment variables to build the connection" do
    ClimateControl.modify(
      PERSONS_API_HOST: "https://test.persons.api",
      PERSONS_API_KEY: "api-key"
    ) do
      client_connection = described_class.new.connection

      expect(client_connection.scheme).to eql "https"
      expect(client_connection.host).to eql "test.persons.api"
      expect(client_connection.headers["ApiKey"]).to eql "api-key"
    end
  end

  describe "#member_for_constituency" do
    context "when passed a known and valid constituency name" do
      subject { described_class.new(connection: test_successful_connection) }

      it "returns a result with the member details inside" do
        result = subject.member_for_constituency("test")

        expect(result.object).to be_a Api::Persons::MemberDetails
        expect(result.error).to be_nil

        member = result.object

        expect(member.name).to eql "First Last"
        expect(member.email).to eql "lastf@parliament.gov.uk"
      end
    end

    context "when passed an unknown yet valid constituency name" do
      subject { described_class.new(connection: test_not_found_connection) }

      it "returns a result with the error inside" do
        result = subject.member_for_constituency("test")

        expect(result.object).to be_nil
        expect(result.error).to be_a Api::Persons::Client::NotFoundError
      end
    end

    context "when an error occurs" do
      subject { described_class.new(connection: test_error_connection) }

      it "returns a result with the error inside" do
        result = subject.member_for_constituency("test")

        expect(result.object).to be_nil
        expect(result.error).to be_a Api::Persons::Client::Error
      end
    end
  end
end

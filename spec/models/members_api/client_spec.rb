require "rails_helper"

RSpec.describe MembersApi::Client do
  it "uses the environment variables to build the connection" do
    ClimateControl.modify(
      MEMBERS_API_HOST: "https://members-api.test"
    ) do
      client_connection = described_class.new.connection

      expect(client_connection.scheme).to eql "https"
      expect(client_connection.host).to eql "members-api.test"
    end
  end

  describe "#constituency_search" do
    let(:client) { described_class.new(connection: fake_successful_constituency_search_connection(fake_response)) }

    subject { client.constituency("St Albans") }

    context "when there is a result" do
      let(:fake_response) { [200, nil, {items: [{value: {name: "St Albans", id: 12345}}]}.to_json] }

      it "returns a Result with the JSON response body and no error" do
        expect(subject.object).to eql("items" => [{"value" => {"name" => "St Albans", "id" => 12345}}])
        expect(subject.error).to be_nil
      end
    end

    context "when there is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(MembersApi::Client::Error)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.other"))
      end
    end

    context "when the connection fails" do
      let(:client) { described_class.new(connection: fake_failed_constituency_search_connection) }

      it "raises an Error" do
        expect { subject }.to raise_error(MembersApi::Client::Error)
      end
    end
  end

  describe "#member_id" do
    let(:client) { described_class.new(connection: fake_successful_constituency_search_connection(fake_response)) }

    context "when there is one result" do
      subject { client.member_id("St Albans") }

      let(:fake_response) do
        [
          200,
          nil,
          {
            items: [{
              value: {
                name: "St Albans", currentRepresentation: {
                  member: {
                    value: {
                      id: 12345
                    }
                  }
                }
              }
            }]
          }.to_json
        ]
      end

      it "returns a the ID" do
        expect(subject).to eql(12345)
      end
    end

    context "when there is more than one result" do
      subject { client.member_id("St A") }

      let(:fake_response) { [200, nil, {items: [{value: {name: "St Albans"}}, {value: {name: "Lewisham West and Penge"}}]}.to_json] }

      it "returns a MultipleResultsError" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(MembersApi::Client::MultipleResultsError)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.multiple", search_term: "St A"))
      end
    end
  end

  def fake_successful_constituency_search_connection(response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Location/Constituency/Search") do |_env|
          response
        end
      end
    end
  end

  def fake_failed_constituency_search_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Location/Constituency/Search") do |_env|
          raise Faraday::Error
        end
      end
    end
  end
end

require "rails_helper"

RSpec.describe Api::MembersApi::Client do
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
        expect(subject.error).to be_a(Api::MembersApi::Client::Error)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.other", search_term: "St Albans", status: 500))
      end
    end

    context "when the connection fails" do
      let(:client) { described_class.new(connection: fake_failed_constituency_search_connection) }

      it "raises an Error" do
        expect { subject }.to raise_error(Api::MembersApi::Client::Error)
      end
    end
  end

  describe "#member_for_constituency" do
    it "returns a hash when successful" do
      fake_client = Api::MembersApi::Client.new
      allow(fake_client).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(4744, nil))
      fake_name = double(Api::MembersApi::MemberName, name_display_as: "Joe Bloggs")
      allow(fake_client).to receive(:member_name).and_return(Api::MembersApi::Client::Result.new(fake_name, nil))
      fake_contact_details = double(find: Api::MembersApi::MemberContactDetails.new.from_hash({email: "joe.bloggs@email.com", line1: "Houses of Parliment", postcode: "SW1A 0AA"}))
      allow(fake_client).to receive(:member_contact_details).and_return(Api::MembersApi::Client::Result.new(fake_contact_details, nil))

      response = fake_client.member_for_constituency("St Albans").object

      expect(response.name).to eq("Joe Bloggs")
      expect(response.email).to eq("joe.bloggs@email.com")
      expect(response.address.line1).to eq("Houses of Parliment")
      expect(response.address.postcode).to eq("SW1A 0AA")
    end

    it "raises an error if the member_contact_details is nil" do
      fake_client = Api::MembersApi::Client.new
      allow(fake_client).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(4744, nil))
      fake_name = double(Api::MembersApi::MemberName, name_display_as: "Joe Bloggs")
      allow(fake_client).to receive(:member_name).and_return(Api::MembersApi::Client::Result.new(fake_name, nil))
      allow(fake_client).to receive(:member_contact_details).and_return(Api::MembersApi::Client::Result.new(nil, nil))

      response = fake_client.member_for_constituency("St Albans")

      expect(response.object).to be_nil
      expect(response.error).to be_a(Api::MembersApi::Client::Error)
      expect(response.error.message).to eq(I18n.t("members_api.errors.contact_details_not_found", member_id: 4744))
    end

    it "logs a warning if there are multiple contact details, and returns a nil object" do
      ClimateControl.modify(
        APPLICATION_INSIGHTS_KEY: "fake-key-1234"
      ) do
        fake_client = Api::MembersApi::Client.new
        allow(fake_client).to receive(:member_id).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::MultipleResultsError.new(I18n.t("members_api.errors.multiple", search_term: "St Albans"))))
        allow(fake_client).to receive(:member_name).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::Error.new))
        allow(fake_client).to receive(:member_contact_details).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::Error.new))

        response = fake_client.member_for_constituency("St Albans")
        expect(response.object).to be_nil
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
        expect(subject.object).to eql(12345)
      end
    end

    context "when there is more than one result" do
      subject { client.member_id("St A") }

      let(:fake_response) { [200, nil, {items: [{value: {name: "St Albans"}}, {value: {name: "Lewisham West and Penge"}}]}.to_json] }

      it "returns a MultipleResultsError" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::MultipleResultsError)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.multiple", search_term: "St A"))
      end
    end

    context "when there are no results" do
      subject { client.member_id("Mars") }

      let(:fake_response) { [200, nil, {items: []}.to_json] }

      it "returns a NotFoundError" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::NotFoundError)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.search_term_not_found", constituency: "Mars"))
      end
    end

    context "when there is any other error" do
      subject { client.member_id("nonexistent place") }

      let(:fake_response) { [404, nil] }

      it "returns an Error" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::Error)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.other", search_term: "nonexistent place", status: 404))
      end
    end
  end

  describe "#member_name" do
    let(:client) { described_class.new(connection: fake_successful_member_connection(1234, fake_response)) }

    subject { client.member_name(1234) }

    context "when the member id is not found" do
      let(:fake_response) { [404, nil, nil] }

      it "returns a Result with a NotFoundError" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::NotFoundError)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.member_not_found", member_id: 1234))
      end
    end

    context "when the member id is found" do
      let(:fake_response) do
        [200, nil, {"value" =>
                       {"id" => 4679,
                        "nameAddressAs" => "Neil O'Brien"}}.to_json]
      end

      it "returns a Result with the JSON response body and no error" do
        expect(subject.object).to be_a(Api::MembersApi::MemberName)
        expect(subject.object.name_address_as).to eq("Neil O'Brien")
        expect(subject.error).to be_nil
      end
    end

    context "when the connection fails" do
      let(:client) { described_class.new(connection: fake_failed_member_connection) }

      it "raises an Error" do
        expect { subject }.to raise_error(Api::MembersApi::Client::Error)
      end
    end

    context "when where is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::Error)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.other"))
      end
    end
  end

  describe "#member_contact_details" do
    let(:client) { described_class.new(connection: fake_successful_member_contact_connection(1234, fake_response)) }

    subject { client.member_contact_details(1234) }

    context "when the member id is not found" do
      let(:fake_response) { [404, nil, nil] }

      it "returns a Result with a NotFoundError" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::NotFoundError)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.member_not_found", member_id: 1234))
      end
    end

    context "when the member id is found" do
      let(:fake_response) do
        [200, nil, {
          "value" => [{
            "type" => "Parliamentary office",
            "typeId" => 1,
            "isPreferred" => false,
            "line1" => "House of Commons",
            "line2" => "London",
            "postcode" => "SW1A 0AA",
            "phone" => "020 7219 8568",
            "email" => "daisy.cooper.mp@parliament.uk"
          },
            {
              "type" => "Constituency office",
              "typeId" => 4,
              "isPreferred" => false,
              "line1" => "Constituency office",
              "phone" => "01727 519900"
            }]
        }.to_json]
      end

      it "returns a Result with the JSON response body and no error" do
        expect(subject.object).to be_a(Array)
        expect(subject.object[0]).to be_a(Api::MembersApi::MemberContactDetails)
        expect(subject.object[0].line1).to eq("House of Commons")
        expect(subject.object[0].postcode).to eq("SW1A 0AA")
        expect(subject.error).to be_nil
      end
    end

    context "when the connection fails" do
      let(:client) { described_class.new(connection: fake_failed_member_contact_connection) }

      it "raises an Error" do
        expect { subject }.to raise_error(Api::MembersApi::Client::Error)
      end
    end

    context "when where is any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns a Result with an Error" do
        expect(subject.object).to be_nil
        expect(subject.error).to be_a(Api::MembersApi::Client::Error)
        expect(subject.error.message).to eq(I18n.t("members_api.errors.other"))
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

  def fake_successful_member_connection(id, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Members/#{id}") do |_env|
          response
        end
      end
    end
  end

  def fake_failed_member_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Members/1234") do |_env|
          raise Faraday::Error
        end
      end
    end
  end

  def fake_successful_member_contact_connection(id, response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Members/#{id}/Contact") do |_env|
          response
        end
      end
    end
  end

  def fake_failed_member_contact_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Members/1234/Contact") do |_env|
          raise Faraday::Error
        end
      end
    end
  end
end

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

  describe "#member_for_postcode" do
    let(:client) { described_class.new(connection: fake_successful_postcode_search_connection(fake_response)) }

    context "when there is an MP for the postcode" do
      let(:fake_response) { [200, nil, {items: [{value: {id: "12345", nameDisplayAs: "Joe Bloggs", nameFullTitle: "Joe Bloggs MP"}}]}.to_json] }

      before do
        fake_contact_details = Api::MembersApi::MemberContactDetails.new.from_hash({email: "joe.bloggs@email.com", line1: "House of Commons", postcode: "SW1A 0AA"})
        allow(client).to receive(:member_contact_details).and_return(Api::MembersApi::Client::Result.new(fake_contact_details, nil))
      end

      it "returns the MP name and details" do
        response = client.member_for_postcode("W1A1AA")

        expect(response.object.name).to eq("Joe Bloggs")
        expect(response.object.email).to eq("joe.bloggs@email.com")
        expect(response.object.address.line1).to eq("House of Commons")
        expect(response.object.address.postcode).to eq("SW1A 0AA")
      end
    end

    context "when the MP is found but the call to get contact details fails" do
      let(:fake_response) { [200, nil, {items: [{value: {id: "12345", nameDisplayAs: "Joe Bloggs", nameFullTitle: "Joe Bloggs MP"}}]}.to_json] }

      before do
        allow(client).to receive(:member_contact_details).and_return(Api::MembersApi::Client::Result.new(nil, Api::MembersApi::Client::NotFoundError))
      end

      it "returns the MP name" do
        response = client.member_for_postcode("W1A1AA")

        expect(response.object.name).to eq("Joe Bloggs")
        expect(response.object.email).to be_nil
        expect(response.object.address.line1).to be_nil
        expect(response.object.address.postcode).to be_nil
      end
    end

    context "when there is no MP for the postcode, or the postcode is not found" do
      let(:fake_response) { [200, nil, {items: []}.to_json] }

      it "returns an error" do
        response = client.member_for_postcode("W1A1AA")

        expect(response.error).to be_a(Api::MembersApi::Client::NotFoundError)
      end

      it "does not try to get the contact details" do
        client.member_for_postcode("W1A1AA")
        expect(client).to_not receive(:contact_details_search)
      end
    end

    context "when there are multiple results for a postcode" do
      let(:fake_response) { [200, nil, {items: [{value: {id: "12345"}}, {value: {id: "56789"}}]}.to_json] }

      it "returns an error" do
        response = client.member_for_postcode("W1A1AA")

        expect(response.object).to be_nil
        expect(response.error).to be_a(Api::MembersApi::Client::MultipleResultsError)
      end
    end

    context "when the response returns a 404" do
      # We believe the API will return a 200 when there are no results, but anticipate a 404 anyway
      let(:fake_response) { [404, nil, nil] }

      it "returns an error" do
        response = client.member_for_postcode("W1A1AA")

        expect(response.object).to be_nil
        expect(response.error).to be_a(Api::MembersApi::Client::NotFoundError)
      end
    end

    context "when the response returns any other error" do
      let(:fake_response) { [500, nil, nil] }

      it "returns an error" do
        response = client.member_for_postcode("W1A1AA")

        expect(response.object).to be_nil
        expect(response.error).to be_a(Api::MembersApi::Client::Error)
        expect(response.error.message).to eq("[MEMBERS API] There was an error connecting to the Members API, status: 500, search_term: W1A1AA")
      end
    end

    context "when the connection fails" do
      let(:client) { described_class.new(connection: fake_failed_postcode_search_connection) }

      it "raises an Error" do
        expect { client.member_for_postcode("W1A1AA") }.to raise_error(Api::MembersApi::Client::Error)
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

      it "returns a Result with the Parliamentary office details *only* and no error" do
        expect(subject.object).to be_a(Api::MembersApi::MemberContactDetails)
        expect(subject.object.line1).to eq("House of Commons")
        expect(subject.object.postcode).to eq("SW1A 0AA")
        expect(subject.object.email).to eq("daisy.cooper.mp@parliament.uk")
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

  def fake_successful_postcode_search_connection(response)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Members/Search") do |_env|
          response
        end
      end
    end
  end

  def fake_failed_postcode_search_connection
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("/api/Members/Search") do |_env|
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

require "rails_helper"

RSpec.describe Api::Azure::DotnetReroutingRulesClient, tag: :rerouting do
  around do |example|
    ClimateControl.modify(
      IDENTITY_ENDPOINT: "http://example.com:42356/msi/token",
      IDENTITY_HEADER: "IDENTITY_HEADER",
      AZURE_SUBSCRIPTION_ID: "AZURE_SUBSCRIPTION_ID",
      AZURE_CLIENT_ID: "AZURE_CLIENT_ID",
      AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME: "AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME",
      AZURE_FRONT_DOOR_PROFILE_NAME: "AZURE_FRONT_DOOR_PROFILE_NAME",
      AZURE_FRONT_DOOR_RULE_SET_NAME: "AZURE_FRONT_DOOR_RULE_SET_NAME"
    ) do
      example.run
    end
  end

  let(:auth_response) do
    OpenStruct.new(
      status: 200,
      body: '{"access_token": "FAKE-ACCESS-TOKEN"}'
    )
  end

  let(:management_api_response) do
    OpenStruct.new(
      status: 200,
      body: <<~JSON
        {
          "name": "rerouteorigin",
          "properties": {
            "ruleSetName": "completedotnetreroute",
            "conditions": [
              {
                "name": "UrlPath",
                "parameters": {
                  "typeName": "DeliveryRuleUrlPathMatchConditionParameters",
                  "operator": "BeginsWith",
                  "negateCondition": false,
                  "matchValues": [
                    "projects/conversions/",
                    "dist",
                    "signin-oidc",
                    "netassets"
                  ],
                  "transforms": []
                }
              }
            ]
          }
        }
      JSON
    )
  end

  let(:management_api_headers) { double("management_api_headers", "[]=": double) }

  let(:managed_identity_auth_client) { instance_double(Faraday::Connection, get: auth_response) }

  let(:management_api_client) do
    instance_double(
      Faraday::Connection,
      get: management_api_response,
      headers: management_api_headers
    )
  end

  before do
    allow(Faraday).to receive(:new).with(
      url: "https://management.azure.com",
      headers: {
        "Content-Type": "application/json",
        "User-Agent": Rails.application.config.dfe_user_agent
      }
    ).and_return(management_api_client)

    allow(Faraday).to receive(:new).with(
      url: "http://example.com:42356/msi/token",
      headers: {
        "Content-Type": "application/json",
        "X-IDENTITY-HEADER": "IDENTITY_HEADER"
      },
      params: {
        "api-version": "2019-08-01",
        resource: "https://management.azure.com/",
        client_id: "AZURE_CLIENT_ID"
      }
    ).and_return(managed_identity_auth_client)
  end

  describe "#get_rules" do
    it "obtains a managed identity auth token for the Azure Client ID" do
      Api::Azure::DotnetReroutingRulesClient.new.get_rules

      expect(managed_identity_auth_client).to have_received(:get)
    end

    context "when the auth request is successful" do
      it "sets the obtained token as the auth bearer token on the management api client" do
        Api::Azure::DotnetReroutingRulesClient.new.get_rules

        expect(management_api_headers).to have_received("[]=")
          .with("Authorization", "Bearer FAKE-ACCESS-TOKEN")
      end

      it "fetches the rules for the AZURE_FRONT_DOOR_RULE_SET_NAME from the management api" do
        Api::Azure::DotnetReroutingRulesClient.new.get_rules

        expect(management_api_client).to have_received(:get).with(
          [
            "/subscriptions/AZURE_SUBSCRIPTION_ID",
            "resourceGroups/AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME",
            "providers/Microsoft.Cdn",
            "profiles/AZURE_FRONT_DOOR_PROFILE_NAME",
            "ruleSets/AZURE_FRONT_DOOR_RULE_SET_NAME",
            "rules/rerouteorigin?api-version=2023-05-01"
          ].join("/")
        )
      end
    end

    context "when the auth request is NOT successful" do
      let(:auth_response) do
        OpenStruct.new(
          status: 401,
          body: "Unauthorised"
        )
      end

      it "raises an error" do
        expect { Api::Azure::DotnetReroutingRulesClient.new.get_rules }
          .to raise_error(
            Api::Azure::DotnetReroutingRulesClient::AuthError,
            /Error obtaining managed identity auth/
          )
      end
    end

    context "when the management api request is successful" do
      it "returns a JSON version of the response body" do
        expect(Api::Azure::DotnetReroutingRulesClient.new.get_rules)
          .to eq(JSON.parse(management_api_response.body))
      end
    end

    context "when the management api request is NOT successful" do
      let(:management_api_response) do
        OpenStruct.new(
          status: 503,
          body: "Unavailable"
        )
      end

      it "raises an error" do
        expect { Api::Azure::DotnetReroutingRulesClient.new.get_rules }
          .to raise_error(Api::Azure::DotnetReroutingRulesClient::Error, /Error fetching re-routing rules/)
      end
    end
  end
end

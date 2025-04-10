require "rails_helper"

RSpec.feature "Service support users can manage dotnet rerouting on Front Door" do
  let(:user) { create(:user, :service_support) }

  around do |example|
    ClimateControl.modify(
      AZURE_INFRA_SUBSCRIPTION_ID: "AZURE_INFRA_SUBSCRIPTION_ID",
      AZURE_INFRA_CLIENT_ID: "AZURE_INFRA_CLIENT_ID",
      AZURE_INFRA_CLIENT_SECRET: "AZURE_INFRA_CLIENT_SECRET",
      AZURE_INFRA_TENANT_ID: "AZURE_INFRA_TENANT_ID",
      AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME: "AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME",
      AZURE_FRONT_DOOR_PROFILE_NAME: "AZURE_FRONT_DOOR_PROFILE_NAME",
      AZURE_FRONT_DOOR_RULE_SET_NAME: "AZURE_FRONT_DOOR_RULE_SET_NAME"
    ) do
      example.run
    end
  end

  before do
    sign_in_with_user(user)
  end

  scenario "view active Front Door rerouting ruleset" do
    given_the_azure_ruleset_is_stubbed
    when_i_view_the_active_ruleset
    then_i_see_a_list_of_patterns
    and_i_see_a_list_of_application_routes
    and_i_see_the_routes_which_match_the_patterns_highlighted
  end

  def given_the_azure_ruleset_is_stubbed
    stub_request(:post, "https://login.microsoftonline.com/AZURE_INFRA_TENANT_ID/oauth2/v2.0/token")
      .to_return(status: 200, body: auth_response, headers: {})

    stub_request(:get, "https://management.azure.com/subscriptions/AZURE_INFRA_SUBSCRIPTION_ID/resourceGroups/AZURE_FRONT_DOOR_RESOURCE_GROUP_NAME/providers/Microsoft.Cdn/profiles/AZURE_FRONT_DOOR_PROFILE_NAME/ruleSets/AZURE_FRONT_DOOR_RULE_SET_NAME/rules/rerouteorigin?api-version=2023-05-01")
      .to_return(status: 200, body: rules_response, headers: {})
  end

  def when_i_view_the_active_ruleset
    click_link(".NET re-routing rules")
  end

  def then_i_see_a_list_of_patterns
    within(".rerouting-patterns") do
      expect(page).to have_content("projects/conversions/")
      expect(page).to have_content("dist")
      expect(page).to have_content("signin-oidc")
      expect(page).to have_content("netassets")

      expect(page).to have_css(".rerouting-pattern", count: 4)
    end
  end

  def and_i_see_a_list_of_application_routes
    within(".app-routes") do
      expect(find_all(".app-route").size).to be > (100)
    end
  end

  def and_i_see_the_routes_which_match_the_patterns_highlighted
    within(".app-routes") do
      expect(page).to have_css(".app-route.rerouting-match", text: "/projects/conversions/:id/edit")
      expect(page).to have_css(".app-route.rerouting-match", text: "/projects/conversions/new")
      expect(page).to have_css(".app-route.rerouting-match", text: "/projects/conversions/new_mat")

      expect(find_all(".app-route.rerouting-match").size).to eq(3)
    end
  end

  def auth_response
    <<~JSON
      {
        "ACCESS_TOKEN": "FAKE-ACCESS-TOKEN"
      }
    JSON
  end

  def rules_response
    <<~JSON
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
  end
end

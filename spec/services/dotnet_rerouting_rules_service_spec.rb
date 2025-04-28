require "rails_helper"

RSpec.describe DotnetReroutingRulesService, tag: :rerouting do
  describe "#fetch" do
    let(:azure_response) do
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
                    "pattern/1",
                    "match/pattern/2"
                  ],
                  "transforms": []
                }
              }
            ]
          }
        }
      JSON
    end

    let(:rules_client) do
      instance_double(Api::Azure::DotnetReroutingRulesClient, get_rules: JSON.parse(azure_response))
    end

    before do
      allow(Api::Azure::DotnetReroutingRulesClient).to receive(:new).and_return(rules_client)
    end

    it "asks DotnetReroutingRulesClient to #get_rules" do
      DotnetReroutingRulesService.new.fetch

      expect(rules_client).to have_received(:get_rules)
    end

    it "returns the list of match patterns" do
      expect(DotnetReroutingRulesService.new.fetch).to eq([
        "pattern/1",
        "match/pattern/2"
      ])
    end
  end
end

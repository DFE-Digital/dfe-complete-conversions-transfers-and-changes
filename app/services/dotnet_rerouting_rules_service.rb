# app/services/dotnet_rerouting_rules_service.rb
class DotnetReroutingRulesService
  def fetch
    if Rails.env.development?
      # Return mock data in development
      mock_rules
    else
      # Use real Azure service in other environments
      rules = Api::Azure::DotnetReroutingRulesClient.new.get_rules
      extract_all_path_patterns(rules)
    end
  end

  private

  def mock_rules
    # Mock response structure that matches what the Azure API would return
    {
      "value" => [
        {
          "properties" => {
            "conditions" => [
              {
                "name" => "UrlPath",
                "parameters" => {
                  "matchValues" => [
                    "projects/conversions/",
                    "dist",
                    "signin-oidc",
                    "netassets"
                  ]
                }
              }
            ]
          }
        }
      ]
    }
  end

  # rule_json: one rule object
  def extract_match_values(rule_json)
    conditions =
      rule_json.dig('properties', 'conditions') ||
      rule_json.dig('properties', 'matchConditions') ||
      []

    request_uri_cond = conditions.find do |c|
      name = (c['name'] || c['type'] || '').to_s
      name.match?(/request\s*uri|requesturi|url\s*path/i)
    end

    params = request_uri_cond &&
             (request_uri_cond['parameters'] || request_uri_cond['matchParameters'])

    values = params && (params['matchValues'] || params['values'])
    Array(values).compact
  end

  # rule_set_json: full rules response
  def extract_all_path_patterns(rule_set_json)
    rules = rule_set_json.dig('value') ||
            rule_set_json.dig('properties', 'rules') ||
            []
    # Ensure we get a flattened array of strings
    rules.flat_map { |r| extract_match_values(r) }.flatten.compact.select { |p| p.is_a?(String) }.uniq
  end
end

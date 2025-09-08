# app/services/dotnet_rerouting_rules_service.rb
class DotnetReroutingRulesService
  def fetch
    begin
      rules = Api::Azure::DotnetReroutingRulesClient.new.get_rules
      Rails.logger.info "Azure Front Door rules response: #{rules.inspect}"
      patterns = extract_all_path_patterns(rules)
      Rails.logger.info "Extracted patterns: #{patterns.inspect}"
      patterns
    rescue Api::Azure::DotnetReroutingRulesClient::Error => e
      Rails.logger.error "Failed to fetch Azure Front Door rules: #{e.message}"
      []
    rescue Api::Azure::DotnetReroutingRulesClient::AuthError => e
      Rails.logger.error "Authentication failed for Azure Front Door: #{e.message}"
      []
    rescue => e
      Rails.logger.error "Unexpected error fetching Azure Front Door rules: #{e.message}"
      []
    end
  end

  private

  # rule_json: one rule object
  def extract_match_values(rule_json)
    return [] unless rule_json.is_a?(Hash)

    Rails.logger.info "Extracting match values from rule: #{rule_json.inspect}"

    conditions =
      rule_json.dig('properties', 'conditions') ||
      rule_json.dig('properties', 'matchConditions') ||
      []

    Rails.logger.info "Found #{conditions.length} conditions"

    request_uri_cond = conditions.find do |c|
      next false unless c.is_a?(Hash)
      
      name = (c['name'] || c['type'] || '').to_s
      Rails.logger.info "Checking condition: #{name}"
      name.match?(/request\s*uri|requesturi|url\s*path/i)
    end

    unless request_uri_cond
      Rails.logger.info "No request URI condition found"
      return []
    end

    Rails.logger.info "Found request URI condition: #{request_uri_cond.inspect}"

    params = request_uri_cond['parameters'] || request_uri_cond['matchParameters']
    unless params.is_a?(Hash)
      Rails.logger.info "No parameters found in condition"
      return []
    end

    values = params['matchValues'] || params['values']
    result = Array(values).compact.select { |v| v.is_a?(String) }
    Rails.logger.info "Extracted values: #{result.inspect}"
    result
  end

  # rule_set_json: full rules response
  def extract_all_path_patterns(rule_set_json)
    return [] unless rule_set_json.is_a?(Hash)

    # The response structure when fetching all rules is different
    rules = rule_set_json.dig('value') || []
    Rails.logger.info "Found #{rules.length} rules in response"
    
    # Filter for rules that contain "completedotnetreroute" in the name to get .NET rerouting patterns
    dotnet_rules = rules.select do |rule|
      rule_name = rule.dig('name') || ''
      rule_set_name = rule.dig('properties', 'ruleSetName') || ''
      Rails.logger.info "Checking rule: #{rule_name}, ruleSetName: #{rule_set_name}"
      
      # Check both rule name and rule set name for .NET rerouting
      rule_name.to_s.downcase.include?('completedotnetreroute') ||
      rule_set_name.to_s.downcase.include?('completedotnetreroute')
    end
    
    Rails.logger.info "Found #{dotnet_rules.length} .NET rerouting rules"
    
    # If no .NET specific rules found, try all rules as fallback
    if dotnet_rules.empty?
      Rails.logger.info "No .NET specific rules found, trying all rules as fallback"
      dotnet_rules = rules
    end
    
    # Ensure we get a flattened array of strings
    patterns = dotnet_rules.flat_map { |r| extract_match_values(r) }.flatten.compact.select { |p| p.is_a?(String) }.uniq
    Rails.logger.info "Extracted patterns from .NET rules: #{patterns.inspect}"
    patterns
  end
end

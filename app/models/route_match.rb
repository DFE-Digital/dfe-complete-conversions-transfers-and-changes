class RouteMatch
  def initialize(route:, matching_patterns:)
    @route = route
    @matching_patterns = matching_patterns
  end

  attr_reader :route

  def match?
    # Flatten and compact the patterns to ensure we have a simple array of strings
    flattened_patterns = @matching_patterns.flatten.compact.select { |p| p.is_a?(String) }
    
    Rails.logger.debug "Checking route '#{route}' against patterns: #{flattened_patterns.inspect}"
    
    result = flattened_patterns.any? do |pattern|
      matches = glob_match?(route, pattern)
      Rails.logger.debug "Pattern '#{pattern}' matches route '#{route}': #{matches}"
      matches
    end
    
    Rails.logger.debug "Route '#{route}' matches any pattern: #{result}"
    result
  end

  # Returns the pattern that matched this route, or nil if no match
  def matching_pattern
    return nil unless match?
    
    flattened_patterns = @matching_patterns.flatten.compact.select { |p| p.is_a?(String) }
    
    flattened_patterns.find do |pattern|
      glob_match?(route, pattern)
    end
  end

  # Returns the route wrapped in highlighting spans if it matches a pattern
  def highlighted_route
    if match?
      Rails.logger.debug "Highlighting route '#{route}' with pattern '#{matching_pattern}'"
      %(<span class="pattern-match">#{route}</span>).html_safe
    else
      route
    end
  end

  private

  def glob_match?(path, pattern)
    # Normalize path to always start with /
    normalized_path = path.start_with?('/') ? path : "/#{path}"
    
    # Check if pattern is a regex (starts with ^)
    if pattern.start_with?('^')
      # This is a regex pattern - use it directly
      # For regex patterns, we test against the path without the leading /
      test_path = normalized_path.sub(/^\//, '')
      Rails.logger.debug "Using regex pattern '#{pattern}' for path '#{test_path}'"
      begin
        result = test_path.match?(Regexp.new(pattern))
        Rails.logger.debug "Regex '#{pattern}' matches path '#{test_path}': #{result}"
        result
      rescue RegexpError => e
        Rails.logger.error "Invalid regex pattern '#{pattern}': #{e.message}"
        false
      end
    elsif pattern.include?('*')
      # This is a wildcard pattern - convert to regex
      # * matches any characters except /
      # ** matches any characters including /
      regex_pattern = pattern
        .gsub(/\*\*/, '.*')  # ** matches any characters including /
        .gsub(/\*/, '[^/]*') # * matches any characters except /
      
      # Add anchors to match the entire path
      regex_pattern = "\\A#{regex_pattern}\\z"
      
      Rails.logger.debug "Converting wildcard pattern '#{pattern}' to regex: '#{regex_pattern}'"
      
      begin
        result = normalized_path.sub(/^\//, '').match?(Regexp.new(regex_pattern))
        Rails.logger.debug "Regex '#{regex_pattern}' matches path '#{normalized_path}': #{result}"
        result
      rescue RegexpError => e
        Rails.logger.error "Invalid wildcard pattern '#{pattern}': #{e.message}"
        false
      end
    elsif pattern.end_with?('/')
      # Pattern ends with / - this is a BeginsWith operator pattern
      # e.g., 'projects/conversions/' matches '/projects/conversions/anything'
      normalized_pattern = "/#{pattern}"
      result = normalized_path.start_with?(normalized_pattern)
      Rails.logger.debug "BeginsWith pattern '#{pattern}' matches path '#{normalized_path}': #{result}"
      result
    else
      # Check if this pattern should use exact matching
      exact_only_patterns = [
        'projects/all/export',
        'projects/all/reports'
      ]
      
      normalized_pattern = "/#{pattern}"
      
      if exact_only_patterns.include?(pattern)
        # Use exact matching only for specific patterns
        result = normalized_path == normalized_pattern
        Rails.logger.debug "Exact-only pattern '#{pattern}' matches path '#{normalized_path}': #{result}"
        result
      else
        # Default: treat as "begins with" for most patterns (like Azure CDN BeginsWith operator)
        # This handles patterns like 'projects/team', 'dist', 'signin-oidc', etc.
        # They should match any route that begins with that pattern
        
        # Check both exact match and begins with
        exact_match = normalized_path == normalized_pattern
        begins_with_match = normalized_path.start_with?(normalized_pattern + '/') || normalized_path.start_with?(normalized_pattern + '?')
        
        result = exact_match || begins_with_match
        Rails.logger.debug "Pattern '#{pattern}' matches path '#{normalized_path}': #{result} (exact: #{exact_match}, begins_with: #{begins_with_match})"
        result
      end
    end
  end
end

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
      %(<span class="pattern-match">#{route}</span>).html_safe
    else
      route
    end
  end

  private

  def glob_match?(path, pattern)
    # Check if pattern is a regex (starts with ^)
    if pattern.start_with?('^')
      # This is a regex pattern - use it directly
      Rails.logger.debug "Using regex pattern '#{pattern}' for path '#{path}'"
      result = path.match?(Regexp.new(pattern))
      Rails.logger.debug "Regex '#{pattern}' matches path '#{path}': #{result}"
      result
    elsif pattern.include?('*')
      # This is a RegEx operator pattern with wildcards
      # Convert glob pattern to regex for wildcard patterns
      # * matches any characters except /
      # ** matches any characters including /
      regex_pattern = pattern
        .gsub(/\*\*/, '.*')  # ** matches any characters including /
        .gsub(/\*/, '[^/]*') # * matches any characters except /
      
      # Add anchors to match the entire path
      regex_pattern = "\\A#{regex_pattern}\\z"
      
      Rails.logger.debug "Converting RegEx pattern '#{pattern}' to regex: '#{regex_pattern}'"
      
      result = path.match?(Regexp.new(regex_pattern))
      Rails.logger.debug "Regex '#{regex_pattern}' matches path '#{path}': #{result}"
      result
    elsif pattern.end_with?('/*')
      # Pattern ends with /* - this is a BeginsWith operator pattern
      # e.g., '/projects/team/*' matches '/projects/team/anything'
      base_pattern = pattern.chomp('/*')
      result = path.start_with?(base_pattern) && path != base_pattern
      Rails.logger.debug "BeginsWith pattern '#{pattern}' (base: '#{base_pattern}') matches path '#{path}': #{result}"
      result
    elsif pattern == '/groups' || pattern == '/search' || pattern == '/cookies' || pattern == '/accessibility' || pattern == '/privacy' || pattern == '/access-denied'
      # These are BeginsWith patterns that don't end with /*
      # They match the exact path and any sub-paths
      result = path == pattern || path.start_with?("#{pattern}/")
      Rails.logger.debug "BeginsWith pattern '#{pattern}' matches path '#{path}': #{result}"
      result
    else
      # For Equal operator patterns, match exactly only
      # e.g., '/projects/all/export' matches only '/projects/all/export' exactly
      result = path == pattern
      Rails.logger.debug "Equal pattern '#{pattern}' matches path '#{path}' exactly: #{result}"
      result
    end
  end
end

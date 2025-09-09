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
    # Check if pattern contains wildcards
    has_wildcards = pattern.include?('*') || pattern.include?('?')
    
    if has_wildcards
      # Convert glob pattern to regex for wildcard patterns
      # * matches any characters except /
      # ** matches any characters including /
      # ? matches single character except /
      regex_pattern = pattern
        .gsub(/\*\*/, '.*')  # ** matches any characters including /
        .gsub(/\*/, '[^/]*') # * matches any characters except /
        .gsub(/\?/, '[^/]')  # ? matches single character except /
      
      # Add anchors to match the entire path
      regex_pattern = "\\A#{regex_pattern}\\z"
      
      Rails.logger.debug "Converting wildcard pattern '#{pattern}' to regex: '#{regex_pattern}'"
      
      result = path.match?(Regexp.new(regex_pattern))
      Rails.logger.debug "Regex '#{regex_pattern}' matches path '#{path}': #{result}"
      result
    else
      # For exact patterns, use "begins with" matching
      # e.g., 'projects/all/export' matches '/projects/all/export', '/projects/all/export/123', etc.
      result = path.start_with?("/#{pattern}") || path == "/#{pattern}" || path == pattern
      Rails.logger.debug "Exact pattern '#{pattern}' begins-with matches path '#{path}': #{result}"
      result
    end
  end
end

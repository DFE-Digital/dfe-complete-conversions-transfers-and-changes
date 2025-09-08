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

  private

  def glob_match?(path, pattern)
    # Convert glob pattern to regex
    # * matches any characters except /
    # ** matches any characters including /
    # ? matches single character except /
    regex_pattern = pattern
      .gsub(/\*\*/, '.*')  # ** matches any characters including /
      .gsub(/\*/, '[^/]*') # * matches any characters except /
      .gsub(/\?/, '[^/]')  # ? matches single character except /
    
    # Add anchors to match the entire path
    regex_pattern = "\\A#{regex_pattern}\\z"
    
    Rails.logger.debug "Converting pattern '#{pattern}' to regex: '#{regex_pattern}'"
    
    result = path.match?(Regexp.new(regex_pattern))
    Rails.logger.debug "Regex '#{regex_pattern}' matches path '#{path}': #{result}"
    result
  end
end

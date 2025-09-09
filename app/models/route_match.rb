class RouteMatch
  def initialize(route:, matching_patterns:)
    @route = route
    @matching_patterns = matching_patterns
  end

  attr_reader :route

  def match?
    !matching_pattern.nil?
  end

  def matching_pattern
    @matching_pattern ||= find_matching_pattern
  end

  def matched_segments
    return [] unless match?
    
    @matched_segments ||= extract_matched_segments(route, matching_pattern)
  end

  def highlighted_route
    return route unless match?
    
    highlighted = route.dup
    matched_segments.each do |segment|
      highlighted.gsub!(segment, "<span class='pattern-match'>#{segment}</span>")
    end
    highlighted.html_safe
  end

  private

  def find_matching_pattern
    # Flatten and compact the patterns to ensure we have a simple array of strings
    flattened_patterns = @matching_patterns.flatten.compact.select { |p| p.is_a?(String) }
    
    Rails.logger.debug "Checking route '#{route}' against patterns: #{flattened_patterns.inspect}"
    
    flattened_patterns.find do |pattern|
      matches = glob_match?(route, pattern)
      Rails.logger.debug "Pattern '#{pattern}' matches route '#{route}': #{matches}"
      matches
    end
  end

  def extract_matched_segments(path, pattern)
    # Convert glob pattern to regex for capturing groups
    regex_pattern = pattern
      .gsub(/\*\*/, '(.*)')  # ** matches any characters including / (capturing)
      .gsub(/\*/, '([^/]*)') # * matches any characters except / (capturing)
      .gsub(/\?/, '([^/])')  # ? matches single character except / (capturing)
    
    # Add anchors to match the entire path
    regex_pattern = "\\A#{regex_pattern}\\z"
    
    Rails.logger.debug "Extracting segments from pattern '#{pattern}' with regex: '#{regex_pattern}'"
    
    match = path.match(Regexp.new(regex_pattern))
    return [] unless match
    
    # Return all captured groups (the matched segments)
    match.captures.compact
  end

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

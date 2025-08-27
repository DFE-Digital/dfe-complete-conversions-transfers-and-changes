class RouteMatch
  def initialize(route:, matching_patterns:)
    @route = route
    @matching_patterns = matching_patterns
  end

  attr_reader :route

  def match?
    # Flatten and compact the patterns to ensure we have a simple array of strings
    flattened_patterns = @matching_patterns.flatten.compact.select { |p| p.is_a?(String) }
    
    flattened_patterns.any? do |pattern|
      route.match?(Regexp.new(Regexp.escape(pattern)))
    end
  end
end

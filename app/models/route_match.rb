class RouteMatch
  def initialize(route:, matching_patterns:)
    @route = route
    @matching_patterns = matching_patterns
  end

  attr_reader :route

  def match?
    @matching_patterns.any? { |pattern| route.match?(pattern) }
  end
end

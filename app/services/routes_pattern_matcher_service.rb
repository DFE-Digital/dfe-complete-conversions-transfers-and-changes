class RoutesPatternMatcherService
  def initialize(patterns:, matcher_class: RouteMatch)
    @matching_patterns = patterns
    @matcher_class = matcher_class
    @application_routes = application_routes
  end

  def call
    application_routes.map do |route|
      @matcher_class.new(route: route, matching_patterns: @matching_patterns)
    end
  end

  private def application_routes
    Rails.application.routes.routes
      .map { |r| r.path.spec.to_s.split("(.:format)").first }
      .sort
      .uniq
  end
end

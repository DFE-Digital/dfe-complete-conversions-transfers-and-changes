class ServiceSupport::DotnetReroutingRulesController < ApplicationController
  after_action :verify_authorized

  def show
    authorize(:rerouting, :show?, policy_class: ReroutingPolicy)

    @patterns = DotnetReroutingRulesService.new.fetch
    @routes = RoutesPatternMatcherService.new(patterns: @patterns).call
    
    # Debug information
    Rails.logger.info "Controller: Found #{@patterns.length} patterns: #{@patterns.inspect}"
    Rails.logger.info "Controller: Found #{@routes.length} routes"
    Rails.logger.info "Controller: Routes with matches: #{@routes.select(&:match?).map(&:route).inspect}"
  end
end
